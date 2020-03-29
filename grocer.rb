require 'pry'
def find_item_by_name_in_collection(name, collection)
  x = 0 
  
  while x < collection.length do 
    if(collection[x][:item] === name)
      return collection[x]
    end 
    x += 1 
  end 
  nil 
end

def consolidate_cart(cart)
 newarr = []
 x = 0 
 
 while x < cart.length do 
   new_item = find_item_by_name_in_collection(cart[x][:item], newarr)
   if(new_item === nil)
     new_item = {
       :item => cart[x][:item],
       :price => cart[x][:price],
       :clearance => cart[x][:clearance],
       :count => 1
     }
     newarr.push(new_item)
   else 
     new_item[:count] += 1
   end 
   x += 1 
 end 
 return newarr 
end

def apply_coupons(cart, coupons)
  x = 0 
  while x < coupons.length do 
    discount = find_item_by_name_in_collection(coupons[x][:item], cart)
    if(discount[:count]/coupons[x][:num] >= 1)
      
      info = {
        :item => "#{coupons[x][:item]} W/COUPON",
        :price => (coupons[x][:cost]/coupons[x][:num]).round(2),
        :clearance => discount[:clearance],
        :count => discount[:count] - (discount[:count] % coupons[x][:num])
      }
      
      cart.push(info)
      discount[:count] %=  coupons[x][:num]
    end 
    x += 1 
  end 
  return cart 
end

def apply_clearance(cart)
  x = 0
  newarr = []

  while x < cart.length do
    item = cart[x]
    if (item[:clearance] === true)
      item[:price] *= 0.8
      (item[:price]).round(2)
    end
    newarr.push(item)
    x += 1 
  end
  return newarr 
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  applied_coupons = apply_coupons(consolidated_cart, coupons)
  clearance = apply_clearance(applied_coupons)
   
  x = 0
  sum = 0
  
  while x < clearance.length do
    sum += clearance[x][:price] * clearance[x][:count]
    x += 1
  end
  if sum > 100
    sum *= 0.9
  end 
  return sum.round(2)
end
