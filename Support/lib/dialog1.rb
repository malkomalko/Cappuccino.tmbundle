module TextMate
  module UI
    class << self
      def dialog1(*args)
        d = Dialog1.new(*args)
        begin          
          yield d.results
        rescue StandardError => error
          puts 'Received exception: ' + error
          puts error.backtrace.join("\n")
        end
      end
    end

    class Dialog1
      attr_accessor :results

      def initialize(*args)
        nib_path, parameters, defaults, options = if args.size > 1
          args
        else
          args = args[0]
          [args[:nib], args[:parameters], args[:defaults], args[:options]]
        end

        command = "#{ENV['DIALOG_1']}"
        command << ' --center'         if options[:center]
        command << ' --modal'          if options[:modal]
        command << ' --quiet'          if options[:quiet]
        command << ' --async-window'   if !options[:modal]
        command << " --parameters #{e_sh parameters.to_plist}}" if parameters
        command << " --defaults #{e_sh defaults.to_plist}}" if defaults
        command << " #{e_sh nib_path}"

        @results = OSX::PropertyList::load `#{command}`
      end
    end
  end
end
