module TextbookListingsHelper
  def condition_to_s(i)
    conditions = ["Poor", "Fair", "Good", "Very Good", "Like New"]
    conditions[i.to_i - 1]
  end
end
