def find_item_by_name_in_collection(name, collection)	
counter = 0
  while counter < collection.size do
  item = collection[counter]
  if (item[:item] == name )
      return item
  end
  counter += 1
	end
	nil
end
  
def increment_count_of_item (cart, item_name)
  cart_index = 0
  while cart_index < cart.size do
    current_item = cart[cart_index]
    if ( current_item[:item] == item_name )
      current_item[:count] += 1
    end
    cart_index += 1
  end
  cart
end
  
  # Implement me first!
  #
  # Consult README for inputs and outputs



  def consolidate_cart(cart)
  updated_cart = Array.new
  
  index = 0
  
  while index < cart.size do
    current_item = cart[index]
    if ( find_item_by_name_in_collection( current_item[:item], updated_cart ) == nil)
      current_item[:count] = 1
      updated_cart.push(current_item)
    else
      increment_count_of_item( updated_cart, current_item[:item] )
    end
    index += 1
  end
  updated_cart
end
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.


def apply_coupons(cart, coupons)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  coupons_index = 0
  
  while coupons_index < coupons.size do
    current_coupon = coupons[coupons_index]
    applicable_for_discount = find_item_by_name_in_collection( current_coupon[:item], cart )
      if ( applicable_for_discount[:count] / current_coupon[:num] >= 1 )
        cart.push( {:item => "#{current_coupon[:item]} W/COUPON",
                    :price => (current_coupon[:cost] / current_coupon[:num]).round(2),
                    :clearance => applicable_for_discount[:clearance],
                    :count => applicable_for_discount[:count] - ( applicable_for_discount[:count] % current_coupon[:num])})
          
        applicable_for_discount[:count] %= current_coupon[:num]
      end
    coupons_index += 1
  end
  cart
end

def apply_clearance(cart)
  cart_index = 0
  ready_for_checkout = Array.new
  
  while cart_index < cart.size do
    current_item = cart[cart_index]
    if ( current_item[:clearance] )
      current_item[:price] = current_item[:price] - ( current_item[:price] * 0.20 )
    end
    ready_for_checkout.push( current_item )
    cart_index += 1 
  end
  ready_for_checkout
end
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart


def checkout(cart, coupons)
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
  checkout = consolidate_cart( cart )
  checkout = apply_coupons( checkout, coupons )
  checkout = apply_clearance( checkout )
  
  index = 0
  grand_total = 0
  
  while index < checkout.size do
    current_item_total = checkout[index][:price] * checkout[index][:count]
    current_item_total.round(2)
    grand_total += current_item_total
    index += 1
  end
  if ( grand_total > 100 )
    grand_total *= 0.90
  end
  grand_total
end
  
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
