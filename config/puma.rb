# puma.rb

# Specifies the number of worker processes to boot.
# The recommended value is usually 2 to 4 workers.
# Each worker process runs an independent Rails application instance.
workers 4

# Specifies the number of threads per worker.
# Puma uses a thread pool to handle concurrent requests within each worker.
# The default is 0:16 (min:max), but setting a specific range is often better.
threads 4, 8

# The socket where Puma will listen for connections.
# 'tcp://0.0.0.0:80' means it listens on all interfaces on port 80.
# You specified port 80.
bind 'tcp://0.0.0.0:80'

# Specifies the path to the application's root directory.
# This assumes you run puma from the Redmine application root.
# directory '/path/to/your/redmine'

# Daemonize the server into the background.
# daemonize true

# Store the pid of the server in the specified file.
# state_path 'tmp/puma.state'
pidfile 'tmp/puma.pid'
state_path 'tmp/puma.state'
activate_control_app 'tcp://127.0.0.1:9293', { no_token: true }

# Use the file specified as the primary output of Puma.
# stdout_redirect 'log/puma.stdout.log', 'log/puma.stderr.log', true

# Allow Puma to be restarted by `rails restart` command.
plugin :tmp_restart

# Code to run before the workers are spawned.
before_fork do
  # This is usually for preloading your application or for closing
  # database connections before the fork.
  # ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end

# Code to run when a worker starts up.
on_worker_boot do
  # Worker-specific setup for database connections.
  # This ensures each worker has its own connection pool.
  # ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

# Environment configuration.
# By default, Puma runs in 'development' unless specified.
environment 'production'