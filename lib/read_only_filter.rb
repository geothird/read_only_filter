module ReadOnlyFilter
  # By Default read only protects create/update/destroy actions
  DEF_METHODS = { create: true, update: true, destroy: true }

  # Default RoutingError
  DEF_CODE = 404

  # Default flash error message
  DEF_MSG = 'Access Denied.'

  # Override base module to include attributes and process_action
  # methods to allow for adding a before filter after class
  # specific before_filters
  ActionController::Base.module_eval do
    # Turn read only on or off true/false
    attr_accessor :toggle_read_only

    class << self
      # attr for storing methods marked read only
      attr_accessor :read_only_methods, :status_code_methods,
        :status_code, :redirect_msg

      # initialize
      def __init_params
        @status_code_methods ||= {}
        @read_only_methods   ||= ReadOnlyFilter::DEF_METHODS.dup
        @status_code         ||= ReadOnlyFilter::DEF_CODE
        @redirect_msg        ||= ReadOnlyFilter::DEF_MSG
      end
      # Read only sets up additional methods to be filtered
      # see read_only_method
      #
      # Usage: read_only only: [:index, :show], except: [:update]
      # Usage: read_only render_error: [:create,:udpate], status_code: 404
      #
      def read_only(args)
        __init_params
        if args
          # include methods
          if args[:only]
            args[:only].each do |one|
              @read_only_methods[one] = true
            end
          end
          # except methods
          if args[:except]
            args[:except].each do |ext|
              @read_only_methods.delete(ext)
            end
          end
          # raise methods
          if args[:render_error]
            args[:render_error].each do |red|
              @status_code_methods[red] = true
            end
          end
          # status code
          if args[:status_code]
            @status_code = args[:status_code]
          end
          # redirect message
          if args[:redirect_msg]
            @redirect_msg = args[:redirect_msg]
          end
        end
      end
    end
    # Override process_action to add before_filter after others
    def process_action(method_name, *args)
      ActionController::Base.before_filter :read_only_method
      super
    end
    # Read only method is a before filter that prevents access
    # to controllers based on if the controller is toggled
    # to be read only `toggle_read_only` and if the method
    # is marked as read only through the read_only_methods attribute.
    #
    # By default read only redirects back with an error message
    # To include instead render status code error template see usage.
    #
    def read_only_method
      if @toggle_read_only
        # Setup defaults if not already initialized
        self.class.__init_params

        # Redirect to :back  or render status_code page
        if self.class.read_only_methods[params[:action].to_sym]
          if self.class.status_code_methods[params[:action].to_sym]
            render(file: File.join(Rails.root, "public/#{self.class.status_code}.html"),
                   status: self.class.status_code, layout: false) and return
          else
            redirect_to :back, flash: { error: self.class.redirect_msg} and return
          end
        end
      end
    end
  end
end
# Extend action controller base with ReadOnlyFilter module
ActionController::Base.send(:extend, ReadOnlyFilter)