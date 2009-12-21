module Urgetopunt
  module Helpers
    def title(text)
      content_for(:title) { text }
    end
    
    def sidebar(&block)
      content_for(:sidebar) { concat capture(&block) }
    end
    
    def table_row_for(record, options = {}, &block)
      classes = [cycle('odd', 'even')] | (options.delete(:class) || '').split(/\s+/)
      options[:class] = classes.join(' ')
      content_tag_for :tr, record, options, &block
    end
    
    def if_exists(record, &block)
      unless record.try(:new_record?)
        block.call
      end
    end
    
    def link_to_show(url, options = {})
      link_to 'view', url, options.reverse_merge(:title => 'View details')
    end
    
    def link_to_edit(url, options = {})
      link_to 'edit', url, options.reverse_merge(:title => 'Edit record')
    end
    
    def link_to_destroy(url, options = {})
      classes = (options.delete(:class) || '').split(/\s+/) | ['destroy']
      link_to 'delete', url, options.reverse_merge(:title => 'Delete record', :class => classes.join(' '))
    end
    
    def link_to_next(url, options = {})
      text = options.delete(:text) || 'Next'
      link_to_if url.present?, "#{text} &raquo;", url, options.reverse_merge(:class => 'next_page', :rel => 'next')
    end
    
    def link_to_previous(url, options = {})
      text = options.delete(:text) || 'Previous'
      link_to_if url.present?, "&laquo; #{text}", url, options.reverse_merge(:class => 'prev_page', :rel => 'prev')
    end
    
    def google_analytics(property_id)
      if Rails.env == 'production'
        javascript_tag <<-END
          var _gaq = _gaq || [];
          _gaq.push(['_setAccount', '#{property_id}']);
          _gaq.push(['_trackPageview']);
          
          (function() {
            var ga = document.createElement('script');
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            ga.setAttribute('async', 'true');
            document.documentElement.firstChild.appendChild(ga);
          })();
        END
      end
    end
  end
end
