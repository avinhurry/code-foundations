module HashTable
  class Chaining
    def initialize(size = 16)
      @size = size

      # each bucket starts as an empty array for chaining. The default is 16 buckets. Each bucket is empty to handle collisions via chaining
      @buckets = Array.new(@size) { [] }

      # tracks number of active entries for load factor calculations
      @count = 0
    end

    def set(key, value)
      # get the bucket corresponding to the key's hash
      bucket = @buckets[index(key)]

      # search for an existing key-value pair
      bucket_exists = bucket.detect { |pair| pair[0] == key }

      if bucket_exists
        # update the value if the key already exists
        bucket_exists[1] = value
      else
        # otherwise push the key value pair into the bucket
        bucket  << [key, value]

        # add 1 to the count and rehash if threshold reached
        @count += 1
        resize_and_rehash if load_factor > 0.75
      end
    end

    def get(key)
      # get the bucket for the key
      bucket = @buckets[index(key)]

      # search for the key
      pair = bucket.detect { |pair| pair[0] == key}

      # if the key exists output the value otherwise output nil
      pair ? pair[1] : nil
    end

    def delete(key)
      # get the bucket for the key
      bucket = @buckets[index(key)]

      # search for the key-value pair
      bucket_exists = bucket.detect { |pair| pair[0] == key}

      # remove if found
      bucket.delete(bucket_exists) if bucket_exists

      # output the value if it's deleted otherwise output nil
      bucket_exists ? bucket_exists[1] : nil
    end

    private

    def load_factor
      @count.to_f / @size
    end

    def resize_and_rehash
      # Double the table size and re insert all key value pairs into their new buckets based on new size.
    
      old_buckets = @buckets
      @size *= 2
      @buckets = Array.new(@size) { [] }
      @count = 0

      old_buckets.each do |bucket|
        bucket.each do |key, value|
          set(key, value)
        end
      end
    end


    def index(key)
      # calculate the bucket index for a given key
      key.hash % @size
    end
  end
end
