---
title: "Gitflow and the case against the Develop branch"
date: 2019-01-19T19:00:00+11:00
draft: false
---

# Gitflow and the case against the Develop branch

I'm about to attempt to convince you that the develop branch is more harm then good in most actively developed codebases.

Im specifically targeting my skepticism to the most common version control paradigm Gitflow. So it makes sense that I give you a little bit of a basic understanding of how it actually works.

After that I'm going to explain where my concerns stem from regarding some of the assumptions gitflow makes, and as a result the rest of the development team make, when using the paradigm.

## What is Gitflow?
Git flow can basically be summed up as the following set of constraints on branch creation and merging:

1. Develop branch is an integration branch (where all the new features and fixes gets integrated together before being packaged into a release branch)
2. Master branch is the most recently released version of the codebase.
3. Features are branched off of the latest commit in the develop branch.
4. Features should never interact with master directly.
5. Once develop has acquired enough new features it is branched off of as a release branch in preparation for a new release.
6. After creating a release no new features can be added to the release, only bug fixes.  
7. After a release branch is complete, it should get merged into master and tagged with a release.
8. Hotfixes are a special case where you can branch off of master and potentially merge back into master with a version number, or merge into the next release.

## Gitflow advantages
When doing development inside of these constraints, we do get some pretty worth while benefits. 

Release candidates are structurally realized inside the codebase repository. It becomes easy for us to assess what is being delivered inside of any single release because we only need to look at the diff between the master and the release branch. 

New features are never accidentally merged into master before  being tested as a part of a summating whole of a release. This means that we never get the issues where new features could potentially cause issues and conflict with other features that are being released at the same time. This is because all feature work would be merged into the develop branch which would then branch into a release, which would likely be tested as a whole unit of work before being merged into master.

Hotfixes are able to be released without being affected by work that is currently in development. This is because we know that master is a snapshot of the most recently deployed codebase, so we simply branch off of master with confidence that we are not going to be releasing anything other than exactly what we have added into our hotfix branch when we merge back into master.

Integration between hotfixes and actively developed feature branches is also accounted for with this approach, by allowing for either release or develop branches (after getting the hotfixes merged/conflict resolved into) to be merged back downstream into any of the feature branches that are being developed, or the fix branches that are being patched into the next release.

Wow this all seems pretty great so far... right?

## So where is the controversy?
Well, the controversy comes into play with the aforementioned "develop" branch. 

From the gitflow paradigm the develop branch is the main integration point and used as the base where all feature work and bug fixes are merged back into. This all seems like a great idea, except when you think about the potential of working on different releases in parallel.

Lets call our next ground breaking feature "Feature A".
We also have another feature "Feature B" that only started development later but is soon realized to be more important to deliver than "Feature A". 

Consider for a moment that "Feature A" has been no small task, and has required several refactoring efforts, and a couple smaller component features all of which have been Peer Reviewed and merged into the develop branch as part of its development.
At this point, we have been told to begin work on "Feature B", if we were following git flow protocol, we would simply branch off develop. However, we can see how this is going to be a problem. Because it means that our high priority feature "Feature B" is going to be contaminated by the work that has been done for "Feature A". Several refactors and micro features later into the develop branch for the sake of "Feature A" has now added a significant amount of risk to "Feature B"'s development and release. After all, no one has tested any of these refactors or mini features because they did not constitute "enough features for a release".

So we have the problem where we cant simply branch off development for new "Feature B" otherwise its going to inadvertently become dependant on "Feature A".
Well at this point you might argue that all you need to do is find a commit in the develop branch history where it is safe (meaning no dependence on "Feature A") to branch off and go from there, right? Wrong! If you have been a developer for a while you know that there is more than likely other features, fixes, and hotfixes that have been merged into develop in and around both Feature A and one another. This means that a lot of the code commits are likely to be at least in some way dependant on "Feature A". So it becomes pretty tricky to find a point in the commit history where you are going to be able to branch whilst including all the hotfixes code dependencies you DO want in the "Feature B" branch and NOT include any code dependencies on "Feature A".

You can imagine this problem only gets worse the more people you have developing inside a codebase at any point in time. Every time someone has finished a fix, feature,or refactor a PR gets made for a merge into develop. This means that the develop branch just keeps getting more and more "dirty" up until a release is eventually made. Every branch that is created off of develop inherits that same "dirty" dependence which slows down the release cycles and adds complexity to how we manage releases.

## So what is the solution?

Well the solution is actually quite simple. `Nothing more nothing less` this is the principal that we should keep to when creating new branches. You should never have more dependance than is absolutely. The simplest way to achieve this is to branch off master, and to always be working towards a release candidate.

What might that look like? Well, lets work though the same "Feature A" "Feature B" example from above.

Consider when we started working on "Feature A". What do we know at this point in time? We know that this feature is going to be developed as part of some release in the future. We may not know which release but we know its going to go somewhere. So lets create a placeholder for that release. I find that the best way to categorize these placeholders are as "deliverables". So we create a `Nothing more nothing less` branch off master and call it "deliverable/feature-a". This is going to be where all of our development for Feature A, it's fix, refactor and feature branches get branched off and merged back into. Its also going to receive any hotfixes that are done for master by merging master back into this container safely at any point in time. In doing this we have a nice and tidy little container that we know is not dependent on anything else outside of its own unit of work and is also not creating false dependance on itself for any of the other work that is being done in parallel (which would have happened if we were merging this work into development).

After "Feature A" is complete, we then **pull** the deliverable into the next release, by creating a release branch off master, and merging our "devlierable/feature-a" branch into that release. *This is different from the gitflow approach where we essentially wait for a clean break in the develop branch and then create a release.* 
This means that our releases are loosely coupled to what we want to be adding and removing from them until the moment where we actually decide to merge some set of deliverables into a release. (Feels more like the Agile dream dont you think).

Now, when we think about having to create "Feature B" we simply branch a "deliverable/feature-b" off of master, and then do our work on branches off of this deliverable.
We also have the flexibility at this point to move this deliverable into any release we want.

We now have separate clean little containers for all the units of work totally independent of one another. You can imagine how the process of keeping deliverables up to date with hotfixes and other releases merged into master could even be an automated process.

What's more is that we can do work that can seemingly hang around outside of release cycles but not go stale, and we never have to halt a release because of any interdependence between deliverables. We also know that if junior developers are following this system, they wont get into tricky situations with managing releases and interdependence of their code.

## Closing remarks
Give me your feedback! I would like to know if anyone sees something that Im potentially overlooking. I'm certainly not the most experienced git user at this point, but I have some serious concerns about how some version control is handled day to day and would like to improve it.