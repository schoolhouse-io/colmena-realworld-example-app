# ![RealWorld Colmena Example App using pure Ruby](/media/logo.png)

> ### This codebase contains real world examples (of event-driven architectures, CQRS, hexagonal architectures, etc.) that adhere to the [RealWorld](https://github.com/gothinkster/realworld) API spec.

### [Referential demo](https://react-redux.realworld.io/)


## How can I run this service?

This repository is packaged with [Docker](https://www.docker.com/). You will also need to have [Docker Compose](https://docs.docker.com/compose/) installed.

For convenience, we provide the following scripts:

* `bin/start` starts the service on port 3000.
* `bin/dev` opens a console with a fully working development environment.
* `bin/test` runs all unit tests + the official [RealWorld API Spec](https://github.com/gothinkster/realworld/tree/master/api) test collection.

If you don't want to use docker, you can take a look at the [Dockerfile](/Dockerfile) and [docker-compose.yml](/docker-compose.yml) to find out what runtime dependencies are required.


## What is Colmena?

Colmena is an architectural style that optimizes the long-term maintainability and scalability of web services.

It draws inspiration from other architectures, patterns and concepts. We will mention these concepts and provide interesting learning resources along the way.


## More names? Why are you doing this to me!?

Don't worry, we're not here to create any new buzzword and you don't need to learn the name _Colmena_.

This is just a combination of other people's ideas and our own. We want to share these ideas with the community because after applying them for serveral years to our codebase, we have found them extremely valuable and practical.

We want to keep this README short and to-the-point, but we're publishing a series of articles diving into the background and analyzing some of the decisions we made and their impact in our codebase:

1. [5 ways to make your codebase withstand the test of time](https://medium.com/@larribas/5-ways-to-make-your-codebase-withstand-the-test-of-time-9f9192ff1763).


## Fair enough. So where do we start?

We start with a cell. __A cell is a self-contained service__ that follows the [hexagonal architecture](https://fideloper.com/hexagonal-architecture). Each cell:

1. Has a clear purpose and responsibility.
1. Has some internal domain that represents, validates and transforms the cell's state.
1. Relies on a series of interfaces to receive input from (and send output to) external services and technologies.
1. Exposes a public API (a contract stating what it can do).

![basic hexagonal cell diagram](/media/basic_cell.png)

You can think of cells as __very small microservices__. In fact, we encourage you to try to make your cells as small as possible. In our experience, granulating your domain around entities and relationships helps understand, test and maintain the codebase in the long run. These are the cells of the RealWorld backend:

* __user__
* __auth__
* __follow__ (user)
* __article__
* __tag__
* __comment__
* __favorite__ article
* (article) __feed__

We know our app is a blogging platform. In that context, the purpose of each cell is pretty clear. It would only take a glance at the [`lib/real_world` directory](https://github.com/schoolhouse-io/colmena-realworld-example-app/tree/master/lib/real_world) to find out where a certain feature might be defined. From there, a developer can quickly look at the API to learn about the operations it supports and navigate the implementation in a very gradual and natural way.


### An event-based, functional domain

Each cell models a small domain. This domain may correspond to an entity (e.g. a user), a relationship (e.g. a user follows another), or a special feature (e.g. each user has a materialized feed of articles).

In _Colmena_, __changes to the domain are represented as a sequence of events__. This sequence of events is append-only, as events are immutable (they are _facts_ that have already taken place). In [event sourcing](https://www.youtube.com/watch?v=8JKjvY4etTY) this sequence is called a "Source of truth", and it provides:

* An audit log of all the actions that have modified the domain.
* The ability for other components (in the same or different cells) to listen to certain events and react to them.

The latter practice is commonly known as _event-driven_ or _reactive programming_, and it has proven a really useful way to implement certain features with very low coupling.

Moreover, since we have a sequence of immutable data, __everything the domain does can be conceived as a pure function__ (no side effects, just deterministic data transformations). In Ruby (or any other object-oriented language for that matter), this translates to:

* No classes, no class instance or methods.
* No calls to any external technology or service.
* No need for stubs, mocks, or any other test artifact that makes our tests slow or complicated.

> We can [validate and describe our app's behavior](https://github.com/schoolhouse-io/colmena-realworld-example-app/blob/master/lib/real_world/follow/domain.rb) in a way that is both simple and very powerful, forgetting about the noise.

![event-based domain visual explanation](/media/evented_domain.png)

### A public contract

Every _useful_ application needs to let the world do something with it. We'll continue with our RealWorld example.

Our `follow` cell is there to fulfil a few use cases:

* A user follows another profile.
* A user stops following another profile.
* Someone wants to know whether a particular user follows a particular profile.
* Someone wants to know which profiles a user is following.

You'll notice the first two use cases are actions that _may_ (if validation rules allow it) change the cell's state, whereas the last two use cases are just querying the current state.

In _Colmena_, we call the former _commands_ and the latter _queries_, and we deal with them in a slightly different way. This pattern is called [CQRS (command-query responsibility segregation)](https://martinfowler.com/bliki/CQRS.html). The linked article does a very good job at explaining the pros and cons of this approach, so we'll focus on our particular implementation for this RealWorld codebase:

![flow diagram explaining what a command does and what a query does](/media/cqrs_sequence_diagram.png)

It is extremely valuable for a project to __make sure the contracts for all these public-facing components are properly documented and semantically versioned__. Developers need to be able to learn and trust, at any point:

* What types of events does this cell publish? What data do they contain?
* Which are the arguments to this command? How about this query?


### Keep ACID properties in mind

Given that this is a distributed architecture with many components and cells working separately, it's fair to wonder... Are changes atomic? How do we keep them consistent?

When commands need to be atomic (they usually do), they are decorated by a transaction. This transaction is responsible for publishing the sequence of events the command generates and running the proper materializers.

These materializers enforce consistency and integrity. . A materializer takes a sequence of events and propagates their changes to the several "read models" the queries use. For instance, a materializer may get the following sequence of events:

```
article_published(...)
article_tagged(...)
```

And perform the following operations:

* Store the whole article in a document-oriented database (e.g. MongoDB) to optimize read operations.
* Store the the article in a reverse index of `tag -> articles` to fetch articles with certain tags.
* Store the article's title and description in a database optimized for search (e.g. ElasticSearch).

![materialization diagram](/media/materialization_diagram.png)

This materialization process can happen synchronously (if consistency is a requirement), or asynchronously (when [eventual consistency](http://guide.couchdb.org/draft/consistency.html) is enough).


### Rely on interfaces, not concrete implementations

At this point, our cell accepts requests from a potentially untrusted source, stores and retrieves data from a database, and may need to call other cells.

These operations are the weak links of software development. The network can fail, databases can be corrupted and public APIs can't be trusted. So, what can we do to minimize these risks?

In _Colmena_, __we define every input/output component as an interface (a port in the hexagonal jargon)__. A particular cell might rely on:

* A repository port, which persists and reads domain data.
* An event publisher port, which allows events to be made public.
* A router port, which communicates with other cells.

In Ruby, we specify the behavior these interfaces should satisfy with a [shared example](https://github.com/schoolhouse-io/colmena-realworld-example-app/blob/master/lib/real_world/follow/ports/repository/spec_shared_examples.rb). All implementations (adapters in the hexagonal jargon) must comply with the spec if they are to be trusted, and provide explicit error handling so that risks can be gracefully handled, logged, and mitigated.

Relying on interfaces is one of the most basic design principles, and it has immediate practical benefits:

* We can write a single test for multiple components.
* We can apply the [dependency inversion principle](https://softwareengineering.stackexchange.com/questions/234747/dependency-inversion-principle-vs-program-to-an-interface-not-an-implementatio) to inject the adapters we need for each environment (e.g. a fast SQLite database for testing and a fully scalable cloud database in production).

> Just remember to fully test all adapters before releasing to production.


### Your application is made up of multiple cells

Cells have clearly defined boundaries, but they still need to communicate with one another. In _Colmena_, cells can talk to each other in two different ways:

* Synchronously, invoking a command or query on the other cell. This is a traditional [remote procedure call](https://en.wikipedia.org/wiki/Remote_procedure_call) we perform through a [central service registry](https://microservices.io/patterns/service-registry.html) we call [_the router_](https://github.com/schoolhouse-io/colmena-realworld-example-app/blob/master/lib/real_world/ports/router/in_memory.rb).
* Asynchronously, listening to events produced by the other cell and reacting to them. We do this through an [event broker](https://github.com/schoolhouse-io/colmena-realworld-example-app/blob/master/lib/real_world/ports/event_broker/in_memory.rb).

> In this example, both the router and event broker ports are implemented in-memory. The beauty of these interfaces is that they can be implemented by a service like RabbitMQ or Amazon Kinesis and connect cells deployed on different parts of the world, or written in different programming languages!

Here are a few examples of how we glue cells together in this RealWorld service:

* A [counter listener](https://github.com/schoolhouse-io/colmena-realworld-example-app/blob/master/lib/real_world/tag/listeners/counter.rb) reacts to tags being added to or removed from an article and it updates a total count on the times a tag has been used. All the while, the `article` cell doesn't even know the `tag` cell exists.
* The `api` cell is a bit special. It exposes some of the behavior of all cells in a RESTful HTTP API. As such, it needs to deal with authentication and authorization, hiding private data and aggregating several operations into [a more useful endpoint](https://github.com/schoolhouse-io/colmena-realworld-example-app/blob/master/lib/real_world/api/commands/api_register.rb), making several sub-calls to other cells in the process. We've recently found out someone named this pattern [API Composition](https://microservices.io/patterns/data/api-composition.html).

![domain, application and framework layers in a cell](/media/cell_layers.png)

## Hence, _Colmena_

We felt it was better to start explaining this architecture from the bottom up, so we haven't had the time to explain properly what the heck a _Colmena_ is.

_Colmena_ means Beehive in Spanish. Like our architecture, :bee:-hives are composed of many small hexagonal units that are isolated from one another but work together as a powerful system. Isn't that beautiful?

Hence, the name.

![a beehive](/media/beehive.jpg)


## Other interesting thoughts

### Testing

* [Test-Driven Development](https://en.wikipedia.org/wiki/Test-driven_development) really shines when you need to think so much about public contracts and abstract interfaces.
* Since we encapsulate all our input/output operation within certain interfaces, we don't need a single stub, mock or test double in our tests, making them very easy to read and maintain.
* [This `subject.clear` method call](https://github.com/schoolhouse-io/colmena-realworld-example-app/blob/master/lib/real_world/auth/ports/repository/spec_shared_examples.rb#L6) is the most awkward piece of test code you'll find in our codebase. We need it to wipe a database clean before each test. Compared to our experience testing class instances, ORM models and the like, we're proud owners of that piece of code.
* We like to keep our test files close to our source code files, contrary to the idiomatic ruby way. We find them easier to find and maintain that way.
* Most tests are highly parallelizable. Build times should decrease linearly with the number of resources you throw in. End-to-end tests are a different story, but hey, hopefully [they'll be small enough](https://martinfowler.com/articles/practical-test-pyramid.html).


### Version control

If each cell is a microservice, why putting them in the same repository?

An interesting advantage to this architectural style is that you can split your repositories according to your team's needs. Do you need to speed up build times? Has your company changed the team structure? Are some cells strictly confidential and reserved for approved eyes only? You got it.


### Packaging and Deployment

If each cell is a microservice, are you saying we should deploy 100 different services?

Of course not. __Cells are only an architectural split__. You may split your repositories according to your development team's preferences, and you may split your deployments according to your systems team's preferences.

* Maybe you thought your `payments` and `product_recommendations` cells were quite unrelated. Guess what? It turns out they scale at about the same pace on black fridays and sales season.
* These other cells need to be on premises and heavily audited because of legal regulations.
* These cells are optional support and we don't need to pay for the extra availability.

You can create some new repositories, add some git submodules and start handpicking and packaging the cells you want toghether.


------

We want this to be an open conversation about architectural ideas and experiences.

You are welcome to comment on any or the articles or open issues in this repository sharing your views, questions or suggestions.


