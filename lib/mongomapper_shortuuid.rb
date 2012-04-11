require 'incrementor'
require 'base32/crockford'

module ShortUUID
  extend ActiveSupport::Concern
  
  module ClassMethods
    def short_uuid!
      key :_id
      class_eval {before_create class_eval { :set_short_uuid } }
    end
  end

  module InstanceMethods
    private

    def set_short_uuid
      seq = MongomapperShortuuid::Incrementor[self.class.name].inc
      self._id = Base32::Crockford.encode("#{seq}#{seconds_since_midnight}".to_i, :length => 8)
    end

    def seconds_since_midnight
      time = Time.now.utc
      time.sec + (time.min * 60) + (time.hour * 3600)
    end
  end
end
