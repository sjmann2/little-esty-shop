  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get '/', to: 'application#welcome'
  
  namespace(:admin) do
    resources(:merchants,     except: [:destroy])
    resources(:invoices,     only: [:index, :show, :update])
  end

  resources(:admin,   only: [:index]) do
    resources(:merchants,     only: [:index])
    resources(:invoices,     only: [:index, :show])
  end

  resources(:items,   only: [:update])

  resources(:merchants,   only: [:show]) do
    get("/dashboard",     to: "merchants#show")
    resources(:invoices,     only: [:index, :show, :update])
    resources(:items, except: [:destroy])
    resources(:bulk_discounts)
  end

  get("/merchants/:id/items/:id",   to: "items#show")
end
