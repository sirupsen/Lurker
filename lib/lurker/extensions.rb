class String
  def usernameify
    split("!")[0][1..-1]
  end
end

class Array
  def messageify
    join(" ")[1..-1]
  end
end
