class Util
  def self.mime_type( extension )
    case extension.gsub( /^\./, '' )
      when 'ico'
        'image/x-icon'
      when 'html'
        'text/html'
      when 'jpg'
        'image/jpg'
      when 'png'
        'image/png'
      default
        nil
    end
  end
end