# Ignite Development Plan

This document tracks upcoming tasks and features for the Ignite project. Add new items here to guide development.

## Upcoming Tasks

### High Priority
- [ ] Configure Phoenix app logging to be more user-friendly
  - Add colors for different components (e.g., GraphQL, GRPC, Database, Web)
  - Add prefixes to identify log sources
  - Make logs easier to read and debug
- [ ] Show server URL in navigation bar
  - Display IP address or Tailscale URL
  - Add copy button for easy sharing
  - Update both Vue.js app and worker page navigation

### Medium Priority
- [ ] Integrate sidekick with macOS notification system
  - Send native macOS notifications for important events
  - Support notification actions and responses
  - Integrate with system notification preferences
- [ ] Integrate with macOS power management to prevent sleep
  - Prevent system sleep during long-running operations
  - Use macOS power assertions API
  - Allow user control over sleep prevention behavior

### Low Priority
- [ ] Add task items here

## Ideas & Future Considerations
- Add future feature ideas here

## Completed Tasks
- [x] Add GitHub link to worker page navigation bar