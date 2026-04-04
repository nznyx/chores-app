# Functional Requirements

---

## User Authentication

### FR-01: User Registration
**Description:** The system shall allow new users to create an account
**Actor:** Guest User
**Input:** Username, email, password
**Output:** Confirmation email sent, account created
**Priority:** High

### FR-02: User Login
**Description:** The system shall authenticate users with email and password
**Actor:** Registered User
**Input:** Email, password
**Output:** JWT access token and refresh token issued, redirect to application
**Priority:** High

### FR-03: Password Reset
**Description:** The system shall allow users to reset forgotten passwords
**Actor:** Registered User
**Input:** Registered email address
**Output:** Password reset link sent to email
**Priority:** Medium

### FR-04: Token Refresh
**Description:** The system shall automatically refresh access tokens using a valid refresh token before the session expires
**Actor:** Authenticated User
**Input:** Valid refresh token
**Output:** New access token issued, old access token invalidated
**Priority:** High

### FR-05: Logout
**Description:** The system shall allow users to log out of the application, invalidating their active tokens
**Actor:** Authenticated User
**Input:** Logout request
**Output:** Access and refresh tokens invalidated, user redirected to login screen
**Priority:** High

### FR-06: Profile Management
**Description:** The system shall allow users to update their display name, avatar image, and email address
**Actor:** Authenticated User
**Input:** Updated display name, avatar, and/or email
**Output:** Profile record updated; if email changed, confirmation sent to new address before it is applied
**Priority:** Medium

---

## Household Management

### FR-07: Create Household
**Description:** The system shall allow any authenticated user to create a new household
**Actor:** Authenticated User
**Input:** Household name (e.g. "City Flat", "Countryside Cottage")
**Output:** Household created; creator automatically assigned the admin role
**Priority:** High

### FR-08: Edit Household
**Description:** The system shall allow household admins to update the household name
**Actor:** Household Admin
**Input:** Updated name and/or location label
**Output:** Household record updated
**Priority:** Medium

### FR-09: Delete Household
**Description:** The system shall allow household admins to permanently delete a household and all of its associated data
**Actor:** Household Admin
**Input:** Household selection, explicit delete confirmation
**Output:** Household, all chores, chore history, memberships, and tags permanently removed
**Priority:** Low

### FR-10: Switch Viewed Household
**Description:** The system shall allow users who belong to multiple households to switch which household they are currently viewing at any time, without changing their active household
**Actor:** Household Member
**Input:** Selected household from household list
**Output:** App view refreshes to show chores, members, and scoreboard for the selected household; the user's active household remains unchanged
**Priority:** High

### FR-11: Switch Active Household
**Description:** The system shall allow users to manually change their active household - the household they are physically present in and currently responsible for
**Actor:** Household Member
**Input:** Active household selection
**Output:** User's active household updated; chore responsibilities and reminders updated accordingly
**Priority:** High

### FR-12: Invite Member to Household
**Description:** The system shall allow household admins to invite other users by email address to join a household
**Actor:** Household Admin
**Input:** Invitee email address, optional role (admin or member)
**Output:** Invitation email sent to invitee; pending invitation record created in the household
**Priority:** High

### FR-13: Accept or Decline Household Invitation
**Description:** The system shall allow invited users to accept or decline a pending household invitation
**Actor:** Invited User
**Input:** Accept or decline action on the invitation
**Output:** On accept - user added to household with the assigned role. On decline - invitation record removed
**Priority:** High

### FR-14: Remove Member from Household
**Description:** The system shall allow household admins to remove a member from the household
**Actor:** Household Admin
**Input:** Target member selection, removal confirmation
**Output:** Member removed; their incomplete assigned tasks are either unassigned or redistributed per admin's choice at removal time
**Priority:** Medium

### FR-15: Leave Household
**Description:** The system shall allow a member to voluntarily leave a household, provided they are not the sole admin
**Actor:** Household Member
**Input:** Leave confirmation
**Output:** Membership removed; incomplete tasks unassigned or redistributed; if the departing member is the only admin, they must promote another member first
**Priority:** Medium

### FR-16: Assign Member Role
**Description:** The system shall allow household admins to change the role of any other member between admin and member
**Actor:** Household Admin
**Input:** Target member, new role selection
**Output:** Role updated; the member's available actions update accordingly
**Priority:** Medium

---

## Active Household & Cross-Household Interaction

### FR-17: Single Active Household Constraint
**Description:** Each user shall have exactly one active household at any given time, representing the household they are currently present in and responsible for
**Actor:** System
**Input:** User profile state
**Output:** Exactly one household marked as active per user at all times; switching active household deactivates the previous one
**Priority:** High

### FR-18: Cross-Household Task Prompt
**Description:** When a user attempts to complete a task belonging to a household other than their currently active one, the system shall prompt them with three options
**Actor:** Household Member
**Input:** Complete action on a task from a non-active household
**Output:** Prompt displayed with three options: (1) Switch active household to this one and complete the task, (2) Complete the task anyway without switching active household, (3) Cancel
**Priority:** High

---

## Vacation Mode

Vacation mode temporarily suspends a member's chore responsibilities in their **origin household**. It optionally supports a **destination household**, which is another household the member belongs to and will be active in during the vacation period. When a destination is specified, the system treats the vacation as a temporary relocation - automatically switching the member's active household on departure and switching it back on return. The origin household's chores are paused or redistributed regardless of whether a destination is set.

### FR-19: Enable Vacation Mode for a Member
**Description:** The system shall allow a member or a household admin to activate vacation mode for one or more members, temporarily suspending their chore responsibilities in the origin household
**Actor:** Household Member / Household Admin
**Input:** Target member(s), optional start date, optional end date, handling preference for origin household (pause or redistribute), optional destination household (must be a household the member already belongs to)
**Output:** Targeted members marked as on vacation in the origin household; their pending tasks paused or redistributed per the selected preference; if a destination household is specified, each affected member's active household is automatically switched to the destination household
**Priority:** High

### FR-20: Enable Vacation Mode for All Members
**Description:** The system shall allow a household admin to activate vacation mode for all members of a household simultaneously, representing a scenario where the entire household relocates temporarily (e.g. everyone moves to the countryside cottage for a period)
**Actor:** Household Admin
**Input:** "Set all to vacation" action, optional start and end dates, handling preference (pause or redistribute), optional destination household shared by all members
**Output:** All members marked as on vacation in the origin household; chores with no remaining active members paused entirely; if a destination household is specified and all members belong to it, each member's active household is switched to the destination household automatically
**Priority:** High

### FR-21: Redistribute Tasks During Vacation
**Description:** When vacation mode is activated with the "redistribute" preference, the system shall reassign the vacationing member's tasks to the remaining active members of the origin household
**Actor:** System
**Input:** Vacation mode activation event with redistribute preference
**Output:** Tasks distributed among remaining active members of the origin household; each affected member notified of newly assigned tasks; tasks with no eligible remaining active member paused until one becomes available
**Priority:** High

### FR-22: Pause Tasks During Vacation
**Description:** When vacation mode is activated with the "pause" preference, or when no active members remain in the origin household to redistribute to, the system shall suspend all affected chores until an active member is available
**Actor:** System
**Input:** Vacation mode activation event with pause preference, or redistribute event with no remaining active members
**Output:** Affected chore instances suspended; no reminders sent; instances resume when at least one active member is available in the origin household
**Priority:** High

### FR-23: Disable Vacation Mode
**Description:** The system shall allow a member or a household admin to deactivate vacation mode, restoring the member's active status in the origin household
**Actor:** Household Member / Household Admin
**Input:** Disable vacation mode action for the target member
**Output:** Member marked as active in the origin household; paused tasks restored to them; redistributed tasks optionally reclaimed based on admin configuration; if a destination household was specified at activation, the member's active household is automatically switched back to the origin household
**Priority:** High

### FR-24: Automatic Vacation Mode Expiry
**Description:** When an end date was specified at activation, the system shall automatically deactivate vacation mode on that date without requiring manual action, applying the same restoration and active household switching rules as manual deactivation
**Actor:** System
**Input:** Scheduled vacation end event
**Output:** Member returned to active status in the origin household; tasks restored; if a destination household was specified, active household switched back to origin automatically
**Priority:** Medium

---

## Permission System

### FR-25: Assign Task-Level Permissions
**Description:** The system shall allow household admins to configure which members or roles are permitted to create and to complete each chore independently
**Actor:** Household Admin
**Input:** Chore selection; list of permitted members or roles for each operation (create, complete)
**Output:** Permission rules persisted against the chore
**Priority:** High

### FR-26: Enforce Task-Level Permissions
**Description:** The system shall enforce task-level permissions server-side, rejecting any create or complete operation attempted by an unauthorized member
**Actor:** System
**Input:** Member action on a chore
**Output:** Action permitted if the member is authorized; rejected with a descriptive error message if not
**Priority:** High

---

## Chore Types

Chores are classified by their **assignment mode**, which determines who is expected to complete them and how completion is tracked.

### FR-27: Individual Chores
**Description:** The system shall support individual chores assigned to one specific member. The admin may additionally configure a fallback permission set of members who are also allowed to complete the chore, enabling redistribution when the primary assignee is unavailable (e.g. on vacation)
**Actor:** Household Admin / Permitted Member
**Input:** Assignee mode set to "individual", primary assignee selected, optional fallback completer list or role
**Output:** A single chore instance created targeting the specified member; only the assigned member (or configured fallback members) may complete it
**Priority:** High

### FR-28: Group Chores
**Description:** The system shall support group chores assigned to a manually selected subset of household members, where each targeted member must complete their own independent instance
**Actor:** Household Admin / Permitted Member
**Input:** Assignee mode set to "group", explicit member selection
**Output:** A separate chore instance generated for each selected member; each member's completion tracked independently; chore considered fully complete only when all selected members have completed their instance
**Priority:** High

### FR-29: All-Members Chores
**Description:** The system shall support all-members chores that behave identically to group chores but automatically target every current active member of the household, without requiring manual member selection
**Actor:** Household Admin / Permitted Member
**Input:** Assignee mode set to "all members"
**Output:** A separate chore instance generated for every active household member; new active members added to the household are included in future instances; completion tracked per member
**Priority:** High

### FR-30: Household Single-Action Chores
**Description:** The system shall support household single-action chores, where the task needs to be completed once by any one eligible member on behalf of the whole household. The chore may optionally be pre-assigned to a specific member, with configurable fallback to all eligible members when that member is unavailable
**Actor:** Household Admin / Permitted Member
**Input:** Assignee mode set to "household single action", optional primary assignee, permission rules for who may complete it
**Output:** A single shared chore instance created; once any one eligible member completes it, the chore is marked done for the entire household and removed from all other members' lists
**Priority:** High

### FR-31: Personal Chores
**Description:** The system shall support personal chores that are not connected to any household and are visible only to the creating user by default. Personal chores appear in the user's personal chore list and contribute exclusively to their personal scoreboard
**Actor:** Authenticated User
**Input:** Chore created with scope set to "personal"
**Output:** Chore created and associated with the user's personal scope only; not visible to any household or other users unless explicitly shared
**Priority:** High

---

## Chore Management

### FR-32: Create Chore
**Description:** The system shall allow authorized users to create a new chore within the active household or in their personal scope
**Actor:** Household Admin / Permitted Member / Authenticated User
**Input:** Title, optional description, scope (personal or household), assignment mode (individual / group / all members / household single action), schedule type (recurring or one-off), due date or recurrence rule, target assignee(s) where applicable, permission rules, tags, optional steps
**Output:** Chore created and scheduled; assigned members notified
**Priority:** High

### FR-33: Edit Chore
**Description:** The system shall allow authorized users to modify the configuration of an existing chore
**Actor:** Household Admin / Permitted Member / Chore Owner (for personal chores)
**Input:** Updated chore fields
**Output:** Chore record updated; if the schedule changed, upcoming instances are recalculated; affected members notified of relevant changes
**Priority:** High

### FR-34: Delete Chore
**Description:** The system shall allow household admins (for household chores) or the owning user (for personal chores) to permanently delete a chore and cancel all upcoming scheduled instances
**Actor:** Household Admin / Chore Owner
**Input:** Chore selection, delete confirmation
**Output:** Chore and all pending instances removed; completion history retained for scoreboard integrity
**Priority:** Medium

### FR-35: Complete Chore
**Description:** The system shall allow a permitted member to mark a chore instance as completed
**Actor:** Permitted Member / Chore Owner
**Input:** Complete action on a chore instance
**Output:** Completion recorded with timestamp and member identity; scoreboard updated; next recurrence scheduled if applicable
**Priority:** High

### FR-36: Recurring Chores
**Description:** The system shall support recurring chores with configurable frequency rules, automatically generating new instances on schedule
**Actor:** Household Admin / Permitted Member / Chore Owner
**Input:** Recurrence rule (e.g. daily, specific days of the week, weekly, monthly, or a custom interval), optional end condition (end date or total occurrence count)
**Output:** Chore instances created automatically according to the recurrence rule until the end condition is met or the chore is deleted
**Priority:** High

### FR-37: One-off Chores
**Description:** The system shall support one-off chores with a single due date that are automatically archived after completion or after the due date has passed
**Actor:** Household Admin / Permitted Member / Chore Owner
**Input:** Single due date/time
**Output:** One chore instance created; archived upon completion or expiry; recorded in history
**Priority:** High

### FR-38: Multi-step Chores
**Description:** The system shall support chores composed of sequential named steps, where each step must be marked complete before the next becomes available
**Actor:** Household Admin / Permitted Member / Chore Owner
**Input:** Ordered list of step names (e.g. Load → Hang → Fold), optional per-step assignee or permission overrides
**Output:** Chore displayed with step progression indicator; subsequent steps locked until previous steps are completed; each step completion recorded separately for history
**Priority:** High

### FR-39: View Chore History
**Description:** The system shall allow household members to view the full completion history of any household chore, and any user to view the history of their own personal chores
**Actor:** Household Member / Authenticated User
**Input:** Chore selection, history view
**Output:** Chronological log of completed instances, each showing completing member name, timestamp, and step-level detail for multi-step chores
**Priority:** Medium

---

## Personal Chore Sharing

### FR-40: Share Personal Chores with Another User
**Description:** The system shall allow a user to share selected personal chores or groups of personal chores (by tag) with a specific other user account, granting them view-only access to progress and completion status
**Actor:** Authenticated User
**Input:** Chore or tag selection, target user account
**Output:** Shared chores visible to the target user in a read-only view; the target user receives a sharing invitation and must accept before gaining access
**Priority:** Medium

### FR-41: Share Personal Chores with a Household
**Description:** The system shall allow a user to share selected personal chores or groups of personal chores (by tag) with an entire household they belong to, granting all household members view-only access to progress and completion status
**Actor:** Authenticated User
**Input:** Chore or tag selection, target household
**Output:** Shared chores visible to all members of the target household in a read-only view
**Priority:** Medium

### FR-42: Revoke Personal Chore Sharing
**Description:** The system shall allow a user to revoke previously granted sharing access for a specific user or household at any time
**Actor:** Authenticated User
**Input:** Sharing record selection, revoke action
**Output:** Access removed; shared chores no longer visible to the revoked party
**Priority:** Medium

---

## Task Presets

### FR-43: Browse Preset Library
**Description:** The system shall provide a built-in library of common chore presets that users can browse and search
**Actor:** Household Admin / Permitted Member
**Input:** Open preset library, optional search query or filter
**Output:** List of available presets with a preview of their default configuration (schedule, steps, tags)
**Priority:** Medium

### FR-44: Create Chore from Preset
**Description:** The system shall allow users to create a new chore by selecting a preset, with all default fields pre-populated and fully editable before saving
**Actor:** Household Admin / Permitted Member
**Input:** Preset selection, optional field overrides
**Output:** Chore creation form opened with preset defaults applied; user can adjust any field before confirming
**Priority:** Medium

### FR-45: Save Configuration as Custom Preset
**Description:** The system shall allow household admins to save an existing chore's configuration as a reusable custom preset, available within that household
**Actor:** Household Admin
**Input:** Chore selection, custom preset name
**Output:** Custom preset saved to the household's preset library and available for future chore creation
**Priority:** Low

---

## Tags

### FR-46: Manage Tags
**Description:** The system shall allow household admins to create, rename, and delete tags within a household; users may also manage tags within their personal chore scope
**Actor:** Household Admin / Authenticated User
**Input:** Tag name, optional colour
**Output:** Tag created, renamed, or deleted; deletion removes the tag from all associated chores without deleting the chores themselves
**Priority:** Medium

### FR-47: Assign Tags to Chores
**Description:** The system shall allow authorized users to assign one or more tags to a chore at creation time or when editing
**Actor:** Household Admin / Permitted Member / Chore Owner
**Input:** Chore creation or edit form, tag selection
**Output:** Selected tags associated with the chore
**Priority:** Medium

### FR-48: Filter Chores by Tag
**Description:** The system shall allow members to filter the chore list by one or more tags
**Actor:** Household Member / Authenticated User
**Input:** Tag filter selection (single or multi-select)
**Output:** Chore list filtered to show only chores that match all selected tags
**Priority:** Medium

---

## Scheduling and Reminders

### FR-49: Configure Reminder Timing
**Description:** The system shall allow per-chore configuration of one or more reminder offsets, specifying how far in advance of the due time notifications should be sent
**Actor:** Household Admin / Permitted Member / Chore Owner
**Input:** One or more reminder offsets per chore (e.g. 30 minutes before, 1 day before)
**Output:** Reminder schedule saved and linked to the chore
**Priority:** High

### FR-50: Send Push Notifications for Due Chores
**Description:** The system shall send push notifications to all eligible members of a chore when a configured reminder threshold is reached or when the chore becomes due
**Actor:** System
**Input:** Scheduled reminder event
**Output:** Push notification delivered to eligible members' devices; notification includes chore title, due time, and a claim action
**Priority:** High

---

## Notification Claiming

### FR-51: Broadcast Task Notification to Multiple Members
**Description:** When a chore is due and has more than one eligible member, the system shall notify all of them simultaneously
**Actor:** System
**Input:** Due chore event, list of eligible members
**Output:** Notification delivered to all eligible members concurrently
**Priority:** High

### FR-52: Claim a Task
**Description:** The system shall allow an eligible member to claim a chore by tapping "I'll do it" in the notification or from within the app
**Actor:** Household Member
**Input:** Claim action on a due chore notification or chore list entry
**Output:** Chore instance assigned to the claiming member; notification dismissed from all other eligible members' devices; chore appears in the claimant's active task list
**Priority:** High

### FR-53: Release a Claimed Task
**Description:** The system shall allow a member who has claimed a task to release it, making it claimable again
**Actor:** Household Member
**Input:** Release action on a currently claimed chore
**Output:** Claim removed; all other eligible members re-notified that the task is available
**Priority:** Medium

---

## Views and Scoreboards

### FR-54: My Chores View
**Description:** The system shall provide a "My Chores" view showing the current user's personal chores and all household chores assigned to them, consolidated in a single list
**Actor:** Authenticated User
**Input:** Navigate to My Chores view
**Output:** Combined list of the user's personal chores and household chores assigned to them, ordered by due date; each chore visually distinguished as personal or household
**Priority:** High

### FR-55: Household Chores View
**Description:** The system shall provide a "Household Chores" view showing all chores within the currently viewed household, each decorated with the profile image(s) of their assigned member(s)
**Actor:** Household Member
**Input:** Navigate to Household Chores view
**Output:** Full list of household chores with assignee avatars visible inline; filterable by tag, status, or assignment mode
**Priority:** High

### FR-56: Household Leaderboard View
**Description:** The system shall display a leaderboard for each household showing each member's completed chore count and contribution score over a selectable time period
**Actor:** Household Member
**Input:** Navigate to Leaderboard view, optional time period filter (current week, current month, all time)
**Output:** Ranked list of household members with their completion count and relative contribution percentage for the selected period; updated in real time when any chore is completed
**Priority:** Medium

### FR-57: Profile View with Personal Scoreboard
**Description:** The system shall provide a Profile view showing the user's account information alongside their personal scoreboard, which tracks completion of personal chores only and is visible exclusively to the user themselves
**Actor:** Authenticated User
**Input:** Navigate to Profile view
**Output:** User's display name, avatar, and personal chore completion statistics over selectable time periods; personal scoreboard entirely separate from any household leaderboard
**Priority:** Medium

### FR-58: Update Scoreboards on Completion
**Description:** The system shall update the relevant scoreboard automatically and in real time when any chore is marked as completed
**Actor:** System
**Input:** Chore completion event with completing member identity and chore scope
**Output:** If a household chore - completing member's score on the household leaderboard incremented and visible to all household members. If a personal chore - user's personal scoreboard updated, visible only to themselves
**Priority:** Medium

---

## Today Widget

### FR-59: Display Today's Tasks in Home Screen Widget
**Description:** The system shall provide a home screen widget that shows the authenticated user's chores due today from their currently active household and their personal chores, without requiring the app to be opened
**Actor:** Authenticated User
**Input:** Widget placed on the device home screen
**Output:** Scrollable list of today's due chores from the active household and personal scope rendered in the widget, refreshed at a configured interval or when the underlying data changes
**Priority:** Medium

### FR-60: Interact with Widget Tasks
**Description:** The system shall allow the user to interact with chore entries directly in the widget
**Actor:** Authenticated User
**Input:** Tap on a chore entry in the widget
**Output:** If the user taps a complete action - chore marked as complete without opening the app. If the user taps the chore title - app opens to the full chore detail screen via deep link
**Priority:** Medium

---

## Self-Hosting

### FR-61: Deploy a Private Backend Instance
**Description:** The system shall provide official container images and configuration documentation to allow technically proficient users to self-host the backend
**Actor:** Self-Hosting User
**Input:** Docker Compose file or equivalent deployment configuration with required environment variables
**Output:** A fully operational private backend instance serving all API endpoints consumed by the client applications
**Priority:** Medium

### FR-62: Point Client to Custom Backend
**Description:** The system shall allow users to configure the client application to communicate with a custom backend URL instead of the default hosted service
**Actor:** Self-Hosting User
**Input:** Custom server base URL entered in the app's server settings screen
**Output:** All API calls, authentication flows, and push notification registrations directed exclusively to the specified backend instance
**Priority:** Medium
