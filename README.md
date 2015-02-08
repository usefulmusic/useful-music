Useful Music
============

Application to sell tracks

### Requirements

Ecomerce cart

### Class Diagram

http://yuml.me/edit/668b5dff
http://yuml.me/edit/230cf55f

### Commands

> Migrate up  
> `sequel -m db/migrations postgres://localhost/useful_music_development`

> Migrate down
> `sequel -m db/migrations postgres://localhost/useful_music_development -M 0`

> Test  
> `rake test`


### Middleware

##### Rack::MethodOverride
will use the _method field in a form to decide the http verb that the application will be shown
[link](http://stackoverflow.com/questions/5166484/sending-a-delete-request-from-sinatra)

### App Comments
Note Factorygirl lint checks be database creation and does not clean up. lint within test space

Note CarrierWave needs root set for url generation when saving to file. Gem could use better error currently unable to coerce nil to string. In app url handled by aws but root needed for testing


### Scorched Comments

##### Render defaults
When inherited the default has references the parent hash rather than having its own copy.
This code will cause bugs in other controllers

```rb
render_defaults[:dir] << '/new_path'
```
Instead use

```rb
render_defaults[:dir] += '/home'
# OR
render_defaults[:dir] = render_defaults[:dir].clone + '/pieces'
```
