# def find_item_by_name_in_collection(name, collection)
#   i = 0
#   while i < collection.length do
#     if collection[i][:item] === name
#     return collection[i]
#   end
#   i += 1
# end

# def consolidate_cart(cart)
#   new_cart = []
  
#   i = 0
#   while i < cart.length do
#     new_cart_method = find_item_by_name_in_collection(cart[i][:item], new_cart)
#     if new_cart[:item] != nil 
#       new_cart_item[i] +=1
#     else new_cart_item = {
#       :item => cart[i][:item],
#       :price => cart[i][:price],
#       :clearance => cart[i][:clearance],
#       :count => 1
#     }
#     new_cart << new_cart_item
#     end
#     i +=1
#   end
#   new_cart
# end 

# def apply_coupons(cart, coupons)
#   i = 0
#   while i < coupons.length do
#     cart_item = find_item_by_name_in_collection(coupons[i][:item], cart)
#     coupon_item_name = "#{coupons[i][:item]} W/COUPON"
#     cart_item_coupons = find_item_by_name_in_collection(coupon_item_name, cart)
#     if cart_item && cart_item[:count] >= coupons[i][:num]
#       if cart_item_coupons
#         cart_item_coupons[:count] += coupons[i][:num]
#         cart_item[i] -= coupons[i][:num]
#       else 
#         cart_item_coupons = {
#           :item => coupon_item_name
#           :price => coupons[i][:price] / coupons[i][:num]
#           :count => coupons[i][:num]
#           :clearance => cart_item[:clearance]
#         }
#         cart << cart_item_coupons
#         cart_item[:count] -= coupons[i][:num]
#       end 
#     end 
#     i += 1
#   end
#   cart
# end

# def apply_clearance(cart)
#   i = 0
#   while i < cart.length do
#     if cart[i][:clearance]
#       cart[i][:price] = (cart[i][:price] - (cart[i][:price] * 0.2)).round(2) 
#     end
#     i += 1
#   end 
#   cart 
# end

# def checkout(cart, coupons)
#   consolidated_ cart = consolidate_cart(cart)
#   couponed_cart = apply_coupons(consolidated_cart)
#   final_cart = apply_clearance(consolidated_cart)
#   total = 0
#   i = 0
#   while i < final_cart.length do
#     total += final_cart[i][:price] * final_cart[i][:count]
#     i += 1  
#   end 
#   if total > 100
#     total = total * 0.90
#   end 
#   total 
# end

CLEARANCE_ITEM_DISCOUNT_RATE = 0.20
BIG_PURCHASE_DISCOUNT_RATE = 0.10

def find_item_by_name_in_collection(name, collection)
  i = 0
  while i < collection.length do
    return collection[i] if name === collection[i][:item]
    i += 1
  end
  nil
end

def consolidate_cart(cart)
  i = 0
  result = []

  while i < cart.count do
    item_name = cart[i][:item]
    sought_item = find_item_by_name_in_collection(item_name, result)
    if sought_item
      sought_item[:count] += 1
    else
      cart[i][:count] = 1
      result << cart[i]
    end
    i += 1
  end

  result
end

# Don't forget, you can make methods to make your life easy!

def mk_coupon_hash(c)
  rounded_unit_price = (c[:cost].to_f * 1.0 / c[:num]).round(2)
  {
    :item => "#{c[:item]} W/COUPON",
    :price => rounded_unit_price,
    :count => c[:num]
  }
end

# A nice "First Order" method to use in apply_coupons

def apply_coupon_to_cart(matching_item, coupon, cart)
  matching_item[:count] -= coupon[:num]
  item_with_coupon = mk_coupon_hash(coupon)
  item_with_coupon[:clearance] = matching_item[:clearance]
  cart << item_with_coupon
end

def apply_coupons(cart, coupons)
  i = 0
  while i < coupons.count do
    coupon = coupons[i]
    item_with_coupon = find_item_by_name_in_collection(coupon[:item], cart)
    item_is_in_basket = !!item_with_coupon
    count_is_big_enough_to_apply = item_is_in_basket && item_with_coupon[:count] >= coupon[:num]

    if item_is_in_basket and count_is_big_enough_to_apply
      apply_coupon_to_cart(item_with_coupon, coupon, cart)
    end
    i += 1
  end

  cart
end

def apply_clearance(cart)
  i = 0
  while i < cart.length do
    item = cart[i]
    if item[:clearance]
      discounted_price = ((1 - CLEARANCE_ITEM_DISCOUNT_RATE) * item[:price]).round(2)
        item[:price] = discounted_price
    end
    i += 1
  end

  cart
end

def checkout(cart, coupons)
  total = 0
  i = 0

  ccart = consolidate_cart(cart)
  apply_coupons(ccart, coupons)
  apply_clearance(ccart)

  while i < ccart.length do
    total += items_total_cost(ccart[i])
    i += 1
  end

  total >= 100 ? total * (1.0 - BIG_PURCHASE_DISCOUNT_RATE) : total
end

# Don't forget, you can make methods to make your life easy!

def items_total_cost(i)
  i[:count] * i[:price]
end