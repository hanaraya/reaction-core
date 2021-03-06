# Define register method
ReactionCore.registerPackage = (packageInfo) ->
  ReactionCore.Packages[packageInfo.name] = packageInfo

# Register core packages
ReactionCore.registerPackage
  name: 'reaction-commerce'
  depends: ['fileUploader', 'staffAccountsManager','paymentMethod', 'mailService', 'analytics', 'shipmentMethod']
  label: 'Core'
  description: 'Reaction Commerce Core'
  icon: 'fa fa-th'
  settingsRoute: 'dashboard/settings/shop'
  overviewRoute: 'dashboard'
  overViewLabel: 'Dashboard'
  overviewIcon: 'fa fa-th'
  priority: '3'
  hidden: false
  autoEnable: true
  hasWidget: false
  shopPermissions: [
    {
      label: "Customers"
      permission: "dashboard/customers"
      group: "Shop Management"
    }
    {
      label: "Promotions"
      permission: "dashboard/promotions"
      group: "Shop Management"
    }
    {
      label: "Products"
      permission: "dashboard/products"
      group: "Shop Content"
    }
    {
      label: "General Shop"
      permission: "dashboard/settings"
      group: "Shop Settings"
    }
  ]

ReactionCore.registerPackage
  name: 'reaction-commerce-orders'
  provides: ['orderManager']
  label: 'Orders'
  description: 'Fulfill your orders'
  icon: 'fa fa-sun-o'
  overviewRoute: 'dashboard/orders'
  hidden: false
  autoEnable: true
  shopPermissions: [
    {
      label: "Orders"
      permission: "dashboard/orders"
      group: "Shop Management"
    }
  ]

ReactionCore.registerPackage
  name: 'reaction-commerce-staff-accounts'
  provides: ['staffAccountsManager']
  label: 'Administrative Users'
  description: 'Administrative user management'
  icon: 'fa fa-users'
  settingsRoute: 'dashboard/settings/account'
  autoEnable: true
  shopPermissions: [
    {
      label: "Dashboard Access"
      permission: "dashboard/settings/account"
      group: "Shop Settings"
    }
  ]

  ReactionCore.registerPackage
    name: 'reaction-commerce-create-products'
    hidden: true
    overviewRoute: 'createProduct'
    overViewLabel: 'Create'
    overviewIcon: 'fa fa-plus'
