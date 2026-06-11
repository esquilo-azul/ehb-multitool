# frozen_string_literal: true

module EhbMultitool
  module ErdTv
    module Upload
      class Directory
        enable_simple_cache
        enable_speaker
        enable_listable
        BOOLEAN_OPTIONS = {
          confirm: false,
          delete: true
        }.freeze
        lists.add_symbol :option, :bbfln90, :source, :source_basename,
                         :source_parent, :target, :target_basename, :target_mkdir, :target_parent,
                         :verbose, *BOOLEAN_OPTIONS.keys

        common_constructor :id, :options do
          self.options = self.class.lists.option.hash_keys_validate!(options.symbolize_keys)
          run
        end

        # @return [Boolean]
        def fat?
          !fuse?
        end

        # @return [Boolean]
        def fuse?
          bbfln90?
        end

        private

        def run
          start_banner
          ::EacRubyUtils::Speaker.context.on(::EacCli::Speaker.new(err_line_prefix: '  ')) do
            run_rsync
          end
        end

        def disk_instance_uncached
          ::Avm::Instances::Base.by_id(::ENV.fetch('ERD_TV_ID'))
        end

        def start_banner
          puts start_banner_parts.map { |label, value| "#{label}: ".cyan + value }.join(' | ')
        end

        def start_banner_parts
          {
            'From' => from, 'To' => to, 'Delete' => delete?.to_s
          }
        end

        BOOLEAN_OPTIONS.each do |key, default_value|
          define_method "#{key}?" do
            options.if_key(key, default_value)
          end
        end

        def run_rsync
          if options.fetch(OPTION_VERBOSE)
            sync.system!(confirm?)
          else
            sync.execute!(confirm?).banner
          end
        end

        def sync_uncached
          ::EacCeMultitool::Fs::RsyncSync.new(from, to, sync_options)
        end

        # @return [Hash]
        def sync_options
          {
            delete: delete?, exclude: ['*.converting', '*.converted'], fat: fat?, fuse: fuse?,
            extra: fat? ? [] : %w[--copy-links], mkdirp: target_mkdir?
          }
        end

        require_sub __FILE__, include_modules: :include
      end
    end
  end
end
