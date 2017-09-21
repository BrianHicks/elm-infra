# Transition Plan From Legacy Elm Infrastructure

elm-lang.org is currently hosted on a DigitalOcean VM.
DNS is handled through DreamHost

## elm-lang.org

We will handle the public website first, since it's not as critical an infrastructure component as the package server.
We'll do this by:

1. Before any operations, checking [DreamHost Status](https://www.dreamhoststatus.com/) and [DigitalOcean status](http://status.digitalocean.com/).
   Do not proceed if any major systems are having issues.
2. Make sure that the existing and new elm-lang.org servers are running the same code
3. Point DNS for www.elm-lang.org and elm-lang.org to the new IP
4. Wait for DNS changeover and test out from a variety of configurations and locations (ask in #elm-dev and #elm-discuss on Slack, for instance.)
5. Wait for a day or two to make sure nothing falls over with production load pointed at it.

## package.elm-lang.org

After we verify that elm-lang.org's transition has worked, we can transition package.elm-lang.org during the Elm 0.19 alpha:

1. Same status checks as before.
   Keep an eye on these!
2. Make sure that the new infrastructure is running the same code, or the latest code from the alpha period.
3. Sync the production package information to the new infrastructure, according to schedule.
4. Add the package site to DNS.
5. Publish an Elm alpha with the new DNS name, or allow the package site location to be configurable in elm-package.
6. Continue syncing package information, according to schedule.

We don't need much of a fallback plan during this alpha.
If something breaks, it breaks, and we'll find it and fix it.
Production traffic **should not** depending on the alpha site, and it has no SLA whatsoever while we shake out the bugs.
We should communicate that to users.

Still needed:

- Can we use alpha.package.elm-lang.org for testing?
- At what times will we sync package information from the old site to the new one? (suggested: daily)
- During the alpha period, will we ever reverse the sync back to the old site? (suggested: no, since it will be 0.19 code)

### promoting new infrastructure and retiring ye olde server for final release of 0.19

1. Lower the TTL on the DNS records to 5 minutes a week or so before.
   (In reality the TTL is some large number of hours, but TTLs are often not respected.)
2. Announce that the old package site will be unavailable for maintenance during a small window.
   Let's say a order of magnitude greater than the lowered TTL (50 minutes, but round to an hour.)
   We *shouldn't* need all this time, but experience suggests building buffer in will be helpful.
3. When the maintenance period begins, turn off the package server process on the old server to remove writes 
4. Make the DNS switch and wait for expiration.
5. Sync the package information from one server to the other.
   We can do this by setting up SSH keys such that we can rsync between the two servers.
   They're both in DigitalOcean's cloud, so this should be a quick operation.
6. Restart the new server processes to make sure that all symlinks are in place.
7. Test test test test test.
   1. Browse packages
   2. Install packages
   3. Publish a package and make sure it shows up in the browser and can be downloaded
   
Still needed:

- What DC is the old VM in?
  New VMs should be brought up in the same DC in order to make package syncing as quick as possible.
- When is the maintenance period?
  It should be scheduled during the lowest traffic for any given day, but I don't have that information.
  If it's late night US time, we should contact large users in TZs (Asia and Australia) directly to let them know about maintenance during their work days.
   
If we need to fall back, roughly the same steps apply but with the targets reversed:

1. Announce fallback
2. Turn off the new server process
3. Sync packages back, if necessary
4. Turn on the old process
5. Reset DNS to the old IP

Still needed:

- Will the 0.18 server work with 0.19 package information present, in case of an emergency halt with sync back?
