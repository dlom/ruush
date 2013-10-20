require "slop"
require "io/console"

module Ruush
  class CLI
    class << self
      def die(message)
        warn message
        exit
      end

      def setup # this whole thing will (hopefully) be cleaned up at a later date
        slop = Slop.new :strict => true, :help => true do |s|
          s.banner "Usage: ruush <command> [options] [<args>]"
          s.on :v, :version, "Print version and exit", :tail => true do puts "ruush v#{Ruush::VERSION} based on puush #{Ruush::PUUSH_VERSION}"; end

          s.command "setup", :help => true do
            description "Interactively set up ~/.ruush"
            banner "Usage: ruush setup [options]"

            run do |opts, args|
              raise Slop::InvalidArgumentError, "Too many arguments (expected zero)" if args.length > 0
              exit if opts.to_h[:help]

              print "Email: "
              email = ($stdin.gets || "").chomp
              print "Password: "
              password = ($stdin.noecho(&:gets) || "").chomp
              print "\n"

              begin
                result = Api::auth_password email, password
                Ruush::config["key"] = result.key
                Ruush::config["email"] = email
                Ruush::config["is_premium"] = result.is_premium
                Ruush::config["usage_bytes"] = result.usage_bytes
                puts "Successfully authenticated with puush"
              rescue BadAuth
                warn "Email or password is incorrect"
              end
            end
          end

          s.command "auth", :help => true do
            description "Authenticate with API key in ~/.ruush"
            banner "Usage: ruush auth [options]"

            run do |opts, args|
              raise Slop::InvalidArgumentError, "Too many arguments (expected zero)" if args.length > 0
              exit if opts.to_h[:help]

              begin
                result = Api::auth_key Ruush::config["key"]
                Ruush::config["is_premium"] = result.is_premium
                Ruush::config["usage_bytes"] = result.usage_bytes
                puts "Successfully authenticated with puush"
              rescue BadAuth
                CLI::die "API key is invalid"
              end
            end
          end

          s.command "upload", :help => true do
            description "Upload a file to puush"
            banner "Usage: ruush upload [options] [<file>]"
            on :s, :silent, "Do not print url"

            run do |opts, args|
              raise Slop::MissingArgumentError, "Missing file argument" if args.length < 1
              raise Slop::InvalidArgumentError, "Too many files (expected one)" if args.length > 1
              exit if opts.to_h[:help]
              CLI::die "Please run `ruush setup` or place your API key in ~/.ruush" if Ruush::config["key"] == ""

              begin
                key = Ruush::config[:key]
                result = Api::upload_file key, File.open(args[0])
                Ruush::config["usage_bytes"] = result.usage_bytes
                puts result.url if !opts.to_h[:silent]
              rescue Error => e
                CLI::die e
              end
            end
          end

          s.command "list", :help => true do
            description "List most recent puushes"
            banner "Usage: ruush list [options]"
            on :f, :files, "Only print filenames"
            on :u, :urls, "Only print URLs"

            run do |opts, args|
              raise Slop::InvalidArgumentError, "Too many arguments (expected zero)" if args.length > 0
              exit if opts.to_h[:help]
              CLI::die "Please run `ruush setup` or place your API key in ~/.ruush" if Ruush::config["key"] == ""

              begin
                history = Api::get_hist Ruush::config["key"]
                history.each do |h|
                  if opts.to_h[:files]
                    puts h.filename
                  elsif opts.to_h[:urls]
                    puts h.url
                  else
                    puts "#{h.url} - #{h.filename}"
                  end
                end
              rescue BadKey => e
                CLI::die "API key is invalid"
              end
            end
          end

          s.command "usage", :help => true do
            description "Display current storage usage"
            banner "Usage: ruush usage [options]"
            on :b, :bytes, "Print usage in bytes"
            on :r, :raw, "Only print byte information (implies --bytes)"

            run do |opts, args|
              raise Slop::InvalidArgumentError, "Too many arguments (expected zero)" if args.length > 0
              exit if opts.to_h[:help]
              CLI::die "Please run `ruush setup` or place your API key in ~/.ruush" if Ruush::config["key"] == ""

              begin
                bytes = Api::get_usage Ruush::config["key"]
                Ruush::config["usage_bytes"] = bytes
                if opts.to_h[:raw]
                  puts bytes
                elsif opts.to_h[:bytes]
                  puts "Current usage: %d bytes" % bytes
                else
                  puts "Current usage: %.2fMB" % (bytes / 1048576.0) # bytes in a megabyte
                end
              rescue BadKey => e
                CLI::die "API key is invalid"
              end
            end
          end

          s.command "help", :help => true do
            description "Alias for `<command> --help`"
            banner "Usage: ruush help <command>"

            run do |opts, args|
              exit if opts.to_h[:help]

              if args.length != 0 and s.commands.has_key? args[0]
                s.commands[args[0]].options.detect { |opt| opt.long == "help" }.call
              else
                s.options.detect { |opt| opt.long == "help" }.call
              end
            end
          end

          s.run do |opts, args|
            if args.length == 0
              if opts.to_hash.values.all? { |x| x.nil? }
                s.options.detect { |opt| opt.long == "help" }.call
              end
            else
              raise Slop::InvalidCommandError, "Unknown command #{args[0]}"
            end
          end
        end
      end

      def run!(argv = ARGV.dup)
        slop = setup
        slop.parse! argv
      end
    end
  end
end
