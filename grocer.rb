def find_item_by_name_in_collection(name, collection)
  
  i  = 0 
  while i < collection.length 
   if collection[i][:item] == name
     return collection[i]
 end	
    i +=1
end
nil
end
      
      


def consolidate_cart(cart)
  new_cart = []
  i = 0 
  while i < cart.length 
  new_cart_item = find_item_by_name_in_collection(cart[i][:item],new_cart)
  if new_cart_item !=nil
    new_cart_item[:count] +=1
  else 
    new_cart_item = {
      :item => cart[i][:item],
      :price => cart[i][:price],
      :clearance => cart[i][:clearance],
      :count => 1 
    }
    
    new_cart << new_cart_item
  end
  i += 1 
end
  new_cart
end

def apply_coupons(cart, coupons)
 counter = 0 
 while counter < coupons.length
 cart_item = find_item_by_name_in_collection(coupons[counter][:item],cart)
 coupon_item_name = "#{coupons[counter][:item]} W/COUPON"
 cart_item_with_coupon = find_item_by_name_in_collection(coupon_item_name,cart)
 if cart_item && cart_item[:count] >= coupons[counter][:num]
   if cart_item_with_coupon
     cart_item_with_coupon[:count] +=coupons[counter][:num]
     cart_item[counter] -= coupon[counter][:num]
   else
     cart_item_with_coupon = {
       :item => coupon_item_name,
       :price => coupons[counter][:cost] / coupons[counter][:num],
       :count => coupons[counter][:num],
       :clearance => cart_item[:clearance]
     }
     cart << cart_item_with_coupon
     cart_item[:count] -= coupons[counter][:num]
   end
 end
 counter +=1 
 end
 cart
end

def apply_clearance(cart)
  counter = 0 
  while counter < cart.length 
  if cart[counter][:clearance]
   cart[counter][:price]  = (cart[counter][:price] - (cart[counter][:price] * 0.2)).round(2)
  end
  
  counter +=1
end
 cart
end

def checkout(cart, coupons)
 consolidated_cart = consolidate_cart(cart)
couponed_cart = apply_coupons(consolidated_cart,coupons)
final_cart = apply_clearance(couponed_cart)

total = 0 
counter = 0 
while counter < final_cart.length

total += final_cart[counter][:price] * final_cart[counter][:count]

counter +=1 
end 
 if total > 100 
  total -= (total * 0.10)
 end
 total
end
