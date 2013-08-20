# set path to app that will be used to configure unicorn,
# note the trailing slash in this example
@dir = "/home/petrovich_demo/current"

worker_processes 2
working_directory @dir

timeout 30

# Specify path to socket unicorn listens to,
# we will use this in our nginx.conf later
listen "/home/petrovich_demo/shared/sockets/unicorn.sock", :backlog => 64

# Set process id path
pid "/home/petrovich_demo/shared/pids/unicorn.pid"

# Set log file paths
stderr_path "/home/petrovich_demo/shared/log/unicorn.stderr.log"
stdout_path "/home/petrovich_demo/shared/log/unicorn.stdout.log"
