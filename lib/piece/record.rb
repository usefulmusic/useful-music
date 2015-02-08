require_relative './uploaders/cover_image_uploader'
require_relative './uploaders/audio_preview_uploader'
require_relative './uploaders/notation_preview_uploader'

class Piece
  class Record < Sequel::Model(:pieces)
    unrestrict_primary_key
    primary_key = :catalogue_number

    one_to_many :item_records, :class => :'Item::Record', :key => :piece_id

    plugin :serialization
    # TODO catalogue_number class throw error when providing bad value
    # serialize_attributes [
    #   lambda{|v| v.match(/UD(\d{4})/)[1].to_i},
    #   lambda{|v| "UD%04d" % v}
    # ], :catalogue_number
    mount_uploader :cover_image, CoverImageUploader
    mount_uploader :audio_preview, AudioPreviewUploader
    mount_uploader :notation_preview, NotationPreviewUploader

    def id
      catalogue_number
    end
    
  end
end
