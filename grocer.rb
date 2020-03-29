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
   if(cart[x][:count]=== nil)
     cart[x][:count] = 1 
     newarr.push(cart[x])
   else 
     cart[x][:count] += 1 
     newarr.push(cart[x])
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
    if cart[x][:clearance] === true 
      cart[x][:price] *= 0.8  
    end
    newarr.push(cart[x][:price])
    x += 1 
  end
  return newarr 
end

def checkout(cart, coupons)
  first = consolidate_cart(cart)
  second = apply_coupons(first, coupons)
  third = apply_clearance(first)
   
  x = 0
  sum = 0
  #binding.pry
  while x < third.length do
    sum  += (third[x][:price] * third[x][:count]).round(2)
    x += 1
  end
  if sum > 100
    sum*=0.9
  end 
  return sum
end
