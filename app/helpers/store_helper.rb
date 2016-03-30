module StoreHelper

	def hidden_div_if(is_empty, attributes = {}, &block)
		if is_empty
			attributes["style"] = "display: none"
		end
		content_tag("div", attributes, &block)
	end
end
