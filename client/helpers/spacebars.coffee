###
# Reaction Handlebars helpers
###

#
# array of months, used by checkout payment methods
# todo:  implement i18n
#
Template.registerHelper "monthOptions", () ->
  monthOptions =
    [
      { value: "", label: "Choose month"}
      { value: "01", label: "1 - January"}
      { value: "02", label: "2 - February" }
      { value: "03", label: "3 - March" }
      { value: "04", label: "4 - April" }
      { value: "05", label: "5 - May" }
      { value: "06", label: "6 - June" }
      { value: "07", label: "7 - July" }
      { value: "08", label: "8 - August" }
      { value: "09", label: "9 - September" }
      { value: "10", label: "10 - October" }
      { value: "11", label: "11 - November" }
      { value: "12", label: "12 - December" }
    ]
  return monthOptions

#
# array of years, used by checkout payment methods
# todo:  implement i18n
#
Template.registerHelper "yearOptions",  () ->
  yearOptions = [{ value: "", label: "Choose year" }]
  year = new Date().getFullYear()
  for x in [1...9] by 1
    yearOptions.push { value: year , label: year}
    year++
  return yearOptions

#
# return path for route
#
Template.registerHelper "pathForSEO", (path, params) ->
  if this[params]
    return "/"+ path + "/" + this[params]
  else
    return Router.path path,this

#
# return user name
#
Template.registerHelper "displayName", () ->
  user = Meteor.user()
  return ""  unless user
  return user.profile.name  if user.profile and user.profile.name
  return user.username  if user.username
  return user.emails[0].address  if user.emails and user.emails[0] and user.emails[0].address
  ""

#
# return social images, defaults to avatar.gif
#
Template.registerHelper "socialImage", () ->
  if Meteor.user().profile?.picture
    return Meteor.user().profile?.picture
  else
    return "/resources/avatar.gif"
#
# decamelSpace
#
Template.registerHelper "camelToSpace", (str) ->
  downCamel = str.replace(/\W+/g, "-").replace /([a-z\d])([A-Z])/g, "$1 $2"
  return downCamel.toLowerCase()

#
# lowerCase string
#
Template.registerHelper "toLowerCase", (str) ->
  return str.toLowerCase()

###
# Methods for the reaction permissions
# https://github.com/ongoworks/reaction#rolespermissions-system
###
Template.registerHelper "hasShopPermission", (permissions) ->
  return ReactionCore.hasPermission(permissions)

Template.registerHelper "hasOwnerAccess", ->
  return ReactionCore.hasOwnerAccess()

Template.registerHelper "hasDashboardAccess", ->
  return ReactionCore.hasDashboardAccess()

Template.registerHelper "activeRouteClass", ->
  args = Array::slice.call(arguments, 0)
  args.pop()
  active = _.any(args, (name) ->
    location.pathname is Router.path(name)
  )
  return active and "active"

Template.registerHelper "siteName", ->
  return Shops.findOne()?.name

###
# methods to return cart calculated values
# cartCount, cartSubTotal, cartShipping, cartTaxes, cartTotal
# are calculated by a transformation on the collection
# and are available to use in template as cart.xxx
# in template: {{cart.cartCount}}
# in code: ReactionCore.Collections.Cart.findOne().cartTotal()
###
Template.registerHelper "cart", () ->
  # return true if there is an issue with the user's cart and we should display the warning icon
  showCartIconWarning: ->
    if @.showLowInventoryWarning()
        return true
    return false

  # return true if any item in the user's cart has a low inventory warning
  showLowInventoryWarning: ->
    storedCart = Cart.findOne()
    if storedCart?.items
      for item in storedCart?.items
        if item.variants?.inventoryPolicy and item.variants?.lowInventoryWarningThreshold
          if (item.variants?.inventoryQuantity <= item.variants.lowInventoryWarningThreshold)
            return true
    return false

  # return true if item variant has a low inventory warning
  showItemLowInventoryWarning: (variant) ->
    if variant?.inventoryPolicy and variant?.lowInventoryWarningThreshold
      if (variant?.inventoryQuantity <= variant.lowInventoryWarningThreshold)
        return true
    return false


###
#  General helpers for template functionality
###

###
# conditional template helpers
# example:  {{#if condition status "eq" ../value}}
###
Template.registerHelper "condition", (v1, operator, v2, options) ->
  switch operator
    when "==", "eq"
      v1 is v2
    when "!=", "neq"
      v1 isnt v2
    when "===", "ideq"
      v1 is v2
    when "!==", "nideq"
      v1 isnt v2
    when "&&", "and"
      v1 and v2
    when "||", "or"
      v1 or v2
    when "<", "lt"
      v1 < v2
    when "<=", "lte"
      v1 <= v2
    when ">", "gt"
      v1 > v2
    when ">=", "gte"
      v1 >= v2
    else
      throw "Undefined operator \"" + operator + "\""

Template.registerHelper "key_value", (context, options) ->
  result = []
  _.each context, (value, key, list) ->
    result.push
      key: key
      value: value
  return result

###
# Convert new line (\n\r) to <br>
# from http://phpjs.org/functions/nl2br:480
###
Template.registerHelper "nl2br", (text) ->
  #        text = Handlebars.Utils.escapeExpression(text);
  nl2br = (text + "").replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, "$1" + "<br>" + "$2")
  new Spacebars.SafeString(nl2br)

###
# format an ISO date using Moment.js
# http://momentjs.com/
# moment syntax example: moment(Date("2011-07-18T15:50:52")).format("MMMM YYYY")
# usage: {{dateFormat creation_date format="MMMM YYYY"}}
###
Template.registerHelper "dateFormat", (context, block) ->
  if window.moment
    f = block.hash.format or "MMM DD, YYYY hh:mm:ss A"
    return moment(context).format(f) #had to remove Date(context)
  else
    return context #  moment plugin not available. return data as is.
  return

Template.registerHelper "uc", (str) ->
  encodeURIComponent str

###
# general helper for plurization of strings
# returns string with 's' concatenated if n = 1
###
Template.registerHelper "pluralize", (n, thing) ->
  # fairly stupid pluralizer
  if n is 1
    "1 " + thing
  else
    n + " " + thing + "s"

###
# general helper user name handling
# todo: needs additional validation all use cases
# returns first word in profile name
###
Template.registerHelper "fname", ->
  if Meteor.user()
    name = Meteor.user().profile.name.split(" ")
    fname = name[0]
  return fname

###
# general helper for determine if user has a store
# returns boolean
###
Template.registerHelper "userHasProfile", ->
  user = Meteor.user()
  return user and !!user.profile.store

Template.registerHelper "userHasRole", (role) ->
  user = Meteor.user()
  return user and user.roles.indexOf(role) isnt -1  if user and user.roles

###
# general helper to return 'active' when on current path
# returns string
# handlebars: {{active 'route'}}
###

#Determine if current link should be active
Template.registerHelper "active", (path) ->
  # Get the current path for URL
  current = Router.current()
  routeName = current and current.route.getName()
  if routeName is path
    return "active"
  else
    return ""

###
# general helper to return 'active' when on current path
# returns string
# handlebars: {{navLink 'projectsList' 'icon-edit'}}
###
Template.registerHelper "navLink", (page, icon) ->
  ret = "<li "
  ret += "class='active'"  if Meteor.Router.page() is page
  ret += "><a href='" + Meteor.Router.namedRoutes[page].path + "'><i class='" + icon + " icon-fixed-width'></i></a></li>"
  return new Spacebars.SafeString(ret)

###
# Returns all packages, both enabled and disabled.
# Combined the info stored in the Packages collection
# with the info provided by the package itself through
# registration.
###
Template.registerHelper "allPackages", ->
  return ReactionCore.Collections.Packages.find({}, {sort: {priority: -1}}).map (pkg) ->
    pkgInfo = pkg.info()
    _.extend pkg, pkgInfo if pkgInfo
    return pkg

###
# For debugging: {{console.log this}}
###
Template.registerHelper "console",
  log: (a) ->
    console.log a
