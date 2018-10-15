module Colmena
  module Cell
    module ClassMethods
      def commands
        @commands ||= {}
      end

      def register_command(command)
        commands[class_to_sym(command)] = command
      end

      def self.class_to_sym(klass)
        name_without_namespace = klass.name.split('::').last
        name_without_namespace.gsub(/([^\^])([A-Z])/,'\1_\2').downcase.to_sym
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end

    def initialize(adapters={})
      @commands = inject_ports(self.class.commands)
    end

    def command(name)
      @commands.fetch(name)
    end

    def commands
      @commands
    end

    private

    def inject_ports(klasses)
      Hash[klasses.map { |name, klass| [name, klass.new(@ports)] }]
    end
  end
end
