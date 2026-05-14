#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class Runner
  runner_with :confirmation, :help do
    desc 'Backup de arquivos pessoais de Eduardo.'
    bool_opt '-v', '--verbose', 'Verbose.'
    bool_opt '-B', '--bbfln90', 'Sincroniza através de bbfln_90.'
    bool_opt '-t', '--target-mkdir', 'Cria o diretório alvo se ele não existir'
    bool_opt '-a', '--all', 'Sync all resources.', usage: true
    pos_arg 'resources', repeat: true, optional: true
  end

  BACKUP = { source_parent: 'storage', target_parent: 'eduardo' }.freeze

  VIDEOS = { source_parent: 'storage/videos', target_parent: 'videos' }.freeze

  RESOURCES = {
    backup: %i[backup_both backup_hd fotos],
    backup_both: BACKUP,
    backup_hd: BACKUP.merge(delete: false),
    fotos: BACKUP.merge(source: 'storage/ehbrs/fotos', target: 'fotos'),
    videos: %i[filmes filmes-alternativas assistidos series videos_ehb videos_rs],
    filmes: VIDEOS,
    'filmes-alternativas' => VIDEOS,
    'assistidos' => VIDEOS.merge(delete: false),
    series: VIDEOS,
    videos_ehb: VIDEOS.merge(source_basename: 'eduardo', target_basename: 'eduardo'),
    videos_rs: VIDEOS.merge(source_basename: 'roseane', target_basename: 'roseane'),
    musicas: { source: 'storage/musicas', target: 'musicas' }
  }.with_indifferent_access.freeze

  def help_extra_text
    "<resources>:\n" + RESOURCES.keys.map { |r| "  #{r}" }.join("\n") # rubocop:disable Style/StringConcatenation
  end

  private

  def bbfln90_start_sshd
    return unless parsed.bbfln90?

    ::Cliutils::Core.command('e/ehbrs/bbfln/90/sshd/start').system!
  end

  def run
    validate_resources
    @resources_to_run = Set.new
    @added_resources = Set.new
    resources_ids.each { |id| add_resource_to_run(id) }
    bbfln90_start_sshd
    @resources_to_run.each do |id|
      ::Cliutils::EhbUbuntuBase0::ErdTv::Upload::Directory.new(id,
                                                               backup_options(RESOURCES.fetch(id)))
    end
  end

  def validate_resources
    resources_ids.each do |id|
      next if RESOURCES.key?(id)

      fatal_error("Recurso \"#{id}\" não existe (Válidos: #{RESOURCES.keys.join(', ')})")
    end
  end

  def resources_ids
    return RESOURCES.keys if parsed.all?

    parsed.resources
  end

  def add_resource_to_run(id)
    id = id.to_sym
    return if @added_resources.include?(id)

    @added_resources << id
    value = RESOURCES.fetch(id)
    if value.is_a?(Hash)
      @resources_to_run << id
    elsif value.is_a?(::Enumerable)
      value.each { |subid| add_resource_to_run(subid) }
    end
  end

  def backup_options(resource_options)
    resource_options.merge(confirm: cached_confirm?('Execução definitiva?'),
                           verbose: parsed.verbose?, target_mkdir: parsed.target_mkdir?,
                           bbfln90: parsed.bbfln90?)
  end
end

Runner.run
