module Rpush
  module Client
    module ActiveModel
      module Gcm
        module Notification
          def self.included(base)
            base.instance_eval do
              #reg_ids may not be presence for topic based push
              #validates :registration_ids, presence: true

              validates_with Rpush::Client::ActiveModel::PayloadDataSizeValidator, limit: 4096
              validates_with Rpush::Client::ActiveModel::RegistrationIdsCountValidator, limit: 1000

              validates_with Rpush::Client::ActiveModel::Gcm::ExpiryCollapseKeyMutualInclusionValidator
            end
          end

          def as_json
            json = {
              'delay_while_idle' => delay_while_idle
            }
            json['registration_ids'] = registration_ids if registration_ids
            json['to'] = data['to'] if data['to']
            json['data'] = data['data'] if data['data'] && !data['notification']
            json['notification'] = data['notification'] if data['notification']
            json['priority'] = data['priority'] if data['priority']
            json['collapse_key'] = collapse_key if collapse_key
            json['time_to_live'] = expiry if expiry
            json
          end
        end
      end
    end
  end
end
