class OpenAddressing
  def initialize(size = 16)
    @size = size

    # each bucket holds one value or nil
    @buckets = Array.new(@size)

    # unique marker for deleted slots
    @tombstone = Object.new
  end

  def set(key, value)
    # Start at the hashed index for the given key
    i = index(key)

    # probe each slot up to @size times (i.e check every slot once, with wrap around, i.e go back to the start of the array if you reach the end.)
    @size.times do
      slot = @buckets[i]

      # If the slot is empty or marked as deleted, insert the key value pair here
      if slot.nil? || slot.equal?(@tombstone)
        @buckets[i] = [key, value]
        return

      # If the key already exists in this slot, update the value
      elsif slot[0] == key
        slot[1] = value
        return
      end

      # Otherwise move to the next slot (with wrap around)
      i = (i + 1) % @size
    end

    # If all the slots are full or conflicted, raise an error
    raise "HashTable is full"
  end

  def get(key)
    # Start at the hashed index for the given key
    i = index(key)

    # probe each slot up to @size times (i.e check every slot once, with wrap around, i.e go back to the start of the array if you reach the end.)
    @size.times do
      slot = @buckets[i]

      # If the slot is empty, the key is not in the table
      return nil if slot.nil?

      # return the value if the slot is not the tombstone and the key matches
      return slot[1] if slot != @tombstone && slot[0] == key

      # Move to the next slot with wrap around
      i = (i + 1) % @size
    end

    # key not found after probing all the slots
    nil
  end

  def delete(key)
    # Start at the hashed index for the given key
    i = index(key)

    # probe each slot up to @size times (i.e check every slot once, with wrap around, i.e go back to the start of the array if you reach the end.)
    @size.times do
      slot = @buckets[i]

    # If the slot is empty, the key is not in the table
      return nil if slot.nil?


    # if the slot is not the tombstone and the key matches delete it and return the value
      if slot != @tombstone && slot[0] == key
        value = slot[1]
        @buckets[i] = @tombstone
        return value
      end

      # Move to the next slot with wrap around
      i = (i + 1) % @size
    end

    # Key not found after probing all the slots
    nil
  end

  private

  def index(key)
    key.hash % @size
  end
end
