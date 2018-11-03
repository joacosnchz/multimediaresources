module MaterialsHelper
  def media_tag_to_show(attachment)
    if (attachment.attach_content_type == 'image/gif') ||
          (attachment.attach_content_type == 'image/jpeg') ||
          (attachment.attach_content_type == 'image/png')
        image_tag attachment.attach.url, :height => 100, :width => 100
    elsif (attachment.attach_content_type == 'video/mp4') ||
        	(attachment.attach_content_type == 'video/x-msvideo') ||
        	(attachment.attach_content_type == 'video/mpeg') ||
        	(attachment.attach_content_type == 'video/mpeg4-generic')
        
        video_tag attachment.attach.url, :width => 100, :height => 100, 
          :style => "max-width: 800px;border: 0;height: auto;outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;vertical-align: bottom;",
          :class => "mcnImage", :type => attachment.attach_content_type
    elsif (attachment.attach_content_type == 'audio/mpeg') ||
          (attachment.attach_content_type == 'audio/ogg') ||
          (attachment.attach_content_type == 'audio/wav') ||
          (attachment.attach_content_type == 'audio/mp3')
        audio_tag attachment.attach.url
    end
  end
end
