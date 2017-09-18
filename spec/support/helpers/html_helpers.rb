module Helpers
  # for Semantic-ui dropdown
  def select_from_dropdown(item_text, options)
    # find dropdown selector
    dropdown = find(options[:from])
    # click on dropdown
    dropdown.click
    # click on menu item
    dropdown.find('.menu .item', text: item_text).click
  end

  def set_input_value(new_value, options)
    find(options[:from]).set(new_value)
  end
end
