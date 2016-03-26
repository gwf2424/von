module ApplicationHelper
	def full_title(page_title = '')
		base_title = "Von's website 1@11. 1*6"
		if page_title.empty?
			base_title
		else
			"#{page_title} | #{base_title}"
		end
	end
end
