class NycNoise< ActiveRecord::Base
  validates :latitude, :longitude, presence: true

  def self.coordinates
    self.select(:latitude, :longitude)
  end

  def self.per_hour(hour)
    self.select(:latitude, :longitude).where('EXTRACT(HOUR FROM created_date) = ?', hour)
  end

  def self.twenty_four
    (0..23).collect do |hour|
      self.per_hour(hour)
    end
  end

  def self.twenty_four_by_description(description)
    (0..23).collect do |hour|
      self.descriptor_per_hour(hour, description)
    end
  end

  def self.descriptor_per_hour(hour, descriptor)
    self.select(:latitude, :longitude, :descriptor).where('EXTRACT(HOUR FROM created_date) = ? AND descriptor = ?', hour, descriptor)
  end

  def self.descriptors
    self.uniq.pluck(:descriptor)
  end

  def self.to_slug(name)
    name.gsub("Noise:", "").gsub(/\(...\)/, "").strip
  end
end
