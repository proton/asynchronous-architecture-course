class GenerateEvent
  include Service

  attr_reader :event_name, :topic, :event_data

  def initialize(event_name, topic, event_data)
    @event_name = event_name
    @topic = topic
    @event_data = event_data
  end

  def call
    WaterDrop::SyncProducer.call(event.to_json, topic: topic)
  end

  private

  def event
    {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_time: Time.now.to_s,
      producer: 'popug_jira',
      event_name: event_name,
      data: event_data
    }
  end
end