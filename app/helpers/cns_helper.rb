module CnsHelper


  def init_icons(page, color, count)
    icons=[]
    1.upto(count) do |i| 
      icon = Variable.new("icon_#{color}#{i}") 
      icons << icon
      page << icon 
    end
    icons
  end

  def get_icon(index, api)
    
    icons_red = @color2icons[:red]
    icons_blue = @color2icons[:blue]
    icons_green = @color2icons[:green]
    icons_yellow = @color2icons[:yellow]
    
    icons_red[index-1]     if api >= 900
    icons_blue[index-1]   if api >= 800 and api < 900
    icons_green[index-1]    if api >= 700 and api < 800
    icons_yellow[index-1]  if api >= 0   and api < 700

  end

end
