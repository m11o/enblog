# rubocop:disable Metrics/BlockLength
namespace :rp do
  desc 'apply ridgepole'
  task :apply, %i[spec_name] => :environment do |_task, args|
    ridgepole('--apply', "--file #{schema}", "--spec-name #{args.spec_name}")
    exec_annotate
  end

  desc 'show diff'
  task :diff, :environment do
    ridgepole('--diff', "#{config} #{schema}")
  end

  desc 'export current db to Schemafile'
  task :export, :environment do
    ridgepole('--export', "--output #{schema}")
  end

  def config
    Rails.root.join('config', 'database.yml')
  end

  def schema
    Rails.root.join('db', 'Schemafile')
  end

  def ridgepole(*options)
    command = ['bundle exec ridgepole', "--config #{config} --env #{Rails.env}"]
    system [command, options].join(' ')
  end

  def exec_annotate
    return unless Rails.env.development?

    system 'bundle exec annotate'
  end
end
# rubocop:enable Metrics/BlockLength
