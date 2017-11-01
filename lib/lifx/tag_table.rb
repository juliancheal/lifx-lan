module LIFX
  # @api private
  class TagTable
    class Entry < Struct.new(:tag_id, :label, :device_id); end

    def initialize(entries: {})
      @entries = Hash.new { |h, k| h[k] = {} }
      entries.each do |k, v|
        @entries[k] = v
      end
    end

    def entries_with(tag_id: nil, device_id: nil, label: nil)
      entries.select do |entry|
        ret = []
        ret << (entry.tag_id == tag_id) if tag_id
        ret << (entry.device_id == device_id) if device_id
        ret << (entry.label == label) if label
        ret.all?
      end
    end

    def entry_with(**args)
      entries_with(**args).first
    end

    def update_table(tag_id: self.tag_id, label: self.label, device_id: self.device_id)
      entry = @entries[device_id][tag_id] ||= Entry.new(tag_id, label, device_id)
      entry.label = label
    end

    def delete_entries_with(tag_id: nil, device_id: nil, label: nil)
      matching_entries = entries_with(tag_id: tag_id, device_id: device_id, label: label)
      matching_entries.each do |entry|
        @entries[entry.device_id].delete(entry.tag_id)
      end
    end

    def tags
      entries.map(&:label).uniq
    end

    def entries
      @entries.values.map(&:values).flatten
    end
  end
end
