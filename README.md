# Wakawaka

## Why?

[Wakatime](https://wakatime.com) is a great service that allows you to track time you spent on projects by logging your text-editor actions to their API.

You set it up by signing up to their service and installing plugins for each of your text editor (for example Vi, XCode...).

However, their freemium model limits you to 7 days of history and stats if you're not willing to pay, and you'll end up loosing your precious data...

Wakawaka intends to fix this by overriding the Wakatime backend connection code, replacing it with your own endpoint. It even proxies the data to Wakatime so you can still have a look to your 7-day history, or subscribe a premium plan and still get your own data.

## Getting started

_This walkthrough assumes you're already successfully sending timelogs to Wakatime!_

```
# Clone and deploy to Heroku
git clone https://github.com/rchampourlier/wakawaka
heroku create wakawakaforme
heroku addons:add mongolab:sandbox
heroku config:set APP_ENV=production
heroku config:set MONGODB_URI=`heroku config:get MONGOLAB_URI`
git push heroku master

# Install Wakawaka (overrides Wakatime plugins' code).
# This will ask for your Wakawaka domain, if you've
# deployed to Heroku with the name above, this will
# be `https://wakawakaforme.herokuapp.com`.
script/install

# Uninstall (restores original Wakatime plugins' code)
script/uninstall
```

## Run locally

```
bundle install

# For development (with code-reload)
shotgun

# Otherwise
rackup

# Console
script/console
```

## For the future

- Add an interface to display all this data.
- Find a better way to "hack" the Wakatime plugins. If the plugin gets updated, we may loose the hack and loose some events in the meanwhile.

## TODO

- Tests
Wakatime service has a freemium model with a 7-day limited history.
