module ApplicationHelper

  def markdown(text)
        renderer = Redcarpet::Render::HTML.new(no_images: true, tables: true, autolink: true,
        strikethrough: true, lax_spacing: true, underline: true, highlight: true, quote: true, footnotes:  true,
        hard_wrap:  true)
        markdown = Redcarpet::Markdown.new(renderer).render(text).html_safe
  end

end
