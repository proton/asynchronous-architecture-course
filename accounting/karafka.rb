# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'development'
ENV['KARAFKA_ENV'] = ENV['RAILS_ENV']
require ::File.expand_path('../config/environment', __FILE__)

Rails.application.eager_load!

# # Zeitwerk custom loader for loading the app components before the whole
# # Karafka framework configuration
# APP_LOADER = Zeitwerk::Loader.new
# APP_LOADER.enable_reloading

# %w[
#   lib
#   app/consumers
#   app/responders
#   app/workers
# ].each(&APP_LOADER.method(:push_dir))

# APP_LOADER.setup
# APP_LOADER.eager_load

class KarafkaApp < Karafka::App
  setup do |config|
    config.kafka.seed_brokers = %w[kafka://127.0.0.1:9092]
    config.client_id = 'accounting'
  end

  # Comment out this part if you are not using instrumentation and/or you are not
  # interested in logging events for certain environments. Since instrumentation
  # notifications add extra boilerplate, if you want to achieve max performance,
  # listen to only what you really need for given environment.
  Karafka.monitor.subscribe(WaterDrop::Instrumentation::StdoutListener.new)
  Karafka.monitor.subscribe(Karafka::Instrumentation::StdoutListener.new)
  Karafka.monitor.subscribe(Karafka::Instrumentation::ProctitleListener.new)

  # Uncomment that in order to achieve code reload in development mode
  # Be aware, that this might have some side-effects. Please refer to the wiki
  # for more details on benefits and downsides of the code reload in the
  # development mode
  #
  # Karafka.monitor.subscribe(
  #   Karafka::CodeReloader.new(
  #     APP_LOADER
  #   )
  # )

  consumer_groups.draw do
    topic "users-stream" do
      consumer UsersConsumer
    end

    topic "tasks-stream" do
      consumer TasksConsumer
    end

    # consumer_group :bigger_group do
    #   topic :test do
    #     consumer TestConsumer
    #   end
    #
    #   topic :test2 do
    #     consumer Test2Consumer
    #   end
    # end
  end
end

Karafka.monitor.subscribe('app.initialized') do
  # Put here all the things you want to do after the Karafka framework
  # initialization
end

KarafkaApp.boot!
