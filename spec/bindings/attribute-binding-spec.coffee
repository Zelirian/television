{Model} = require 'telepath'
television = require '../../src/television'

describe "AttributeBinding", ->
  [tv, User] = []

  beforeEach ->
    class User extends Model
      @property 'avatarUrl'

    tv = television()

  describe "when bound via the x-bind-attribute- attribute", ->
    it "assigns the specified attribute on the element with the value of the bound property", ->
      tv.register
        name: 'UserView'
        content: -> @img 'x-bind-attribute-src': "avatarUrl", src: "placeholder.png"

      user = User.createAsRoot(avatarUrl: "/images/john.png")
      {element} = tv.buildView(user)
      expect(element.outerHTML).toBe '<img x-bind-attribute-src="avatarUrl" src="/images/john.png" />'
      user.avatarUrl = "/images/jane.png"
      expect(element.outerHTML).toBe '<img x-bind-attribute-src="avatarUrl" src="/images/jane.png" />'
      user.avatarUrl = null
      expect(element.outerHTML).toBe '<img x-bind-attribute-src="avatarUrl" src="placeholder.png" />'

    it "removes the attribute entirely if there is no placeholder value and the bound value is null", ->
      tv.register
        name: 'UserView'
        content: -> @img 'x-bind-attribute-src': "avatarUrl"

      user = User.createAsRoot(avatarUrl: "/images/john.png")
      {element} = tv.buildView(user)
      expect(element.outerHTML).toBe '<img x-bind-attribute-src="avatarUrl" src="/images/john.png" />'
      user.avatarUrl = null
      expect(element.outerHTML).toBe '<img x-bind-attribute-src="avatarUrl" />'

  describe "when bound via an attribute temlpate", ->
    it "assigns the attribute on the element with the value of the template", ->
      User.properties 'gender', 'mood'

      tv.register
        name: 'UserView'
        content: -> @div class: "user {{gender}} {{mood}}"

      user = User.createAsRoot(gender: "male", mood: "excited")
      {element} = tv.buildView(user)
      expect(element.outerHTML).toBe '<div class="user male excited"></div>'

      user.gender = "female"
      user.mood = "happy"
      expect(element.outerHTML).toBe '<div class="user female happy"></div>'
