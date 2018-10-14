app_path = "#{File.expand_path(__dir__)}/.."

directory app_path
workers (ENV['WEB_CONCURRENCY'] || `getconf _NPROCESSORS_ONLN`).to_i
