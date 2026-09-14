# GPS-WOX API Documentation

**Base URL:** `http://your-domain.com/api`

**Authentication:** All authenticated endpoints require the `user_api_hash` parameter in the request body.

**Response Format:** All responses are JSON with a `status` field (`1` = success, `0` = failure).

---

## Table of Contents

1. [Authentication](#1-authentication)
2. [Password Reminder](#2-password-reminder)
3. [User Data](#3-user-data)
4. [Devices](#4-devices)
5. [Device Sensors](#5-device-sensors)
6. [Device Services](#6-device-services)
7. [Alerts](#7-alerts)
8. [Geofences](#8-geofences)
9. [History](#9-history)
10. [Events](#10-events)
11. [Routes](#11-routes)
12. [Reports](#12-reports)
13. [POIs / Map Icons](#13-pois--map-icons)
14. [Send Commands](#14-send-commands)
15. [Drivers](#15-drivers)
16. [Custom Events](#16-custom-events)
17. [SMS Templates](#17-sms-templates)
18. [GPRS Templates](#18-gprs-templates)
19. [Sharing](#19-sharing)
20. [Checklists](#20-checklists)
21. [Checklist Templates](#21-checklist-templates)
22. [Services (Device Maintenance)](#22-services-device-maintenance)
23. [Call Actions](#23-call-actions)
24. [Custom Fields](#24-custom-fields)
25. [Task Sets](#25-task-sets)
26. [Tasks](#26-tasks)
27. [Account Settings](#27-account-settings)
28. [Device Media](#28-device-media)
29. [Chat](#29-chat)
30. [Address / Geolocation](#30-address--geolocation)
31. [FCM Token](#31-fcm-token)
32. [Admin - Clients](#32-admin---clients)
33. [Admin - Devices](#33-admin---devices)
34. [Admin - Companies](#34-admin---companies)
35. [Tracker App](#35-tracker-app)
36. [Groups Management](#36-groups-management)

---

## 1. Authentication

### Login
```
POST /api/login
```
**Rate Limit:** Configurable via `config('server.api_login_throttle')`

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `email` | string | Yes | User email address |
| `password` | string | Yes | User password |

**Response (Success):**
```json
{
    "status": 1,
    "user_api_hash": "hash_string",
    "permissions": { ... }
}
```

**Response (Failure):**
```json
{
    "status": 0,
    "message": "Login failed"
}
```

---

## 2. Password Reminder

### Request Reset Code
```
GET /api/password_reminder
```
**Rate Limit:** 2 per minute

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `email` | string | Yes | Registered email address |

**Response:**
```json
{ "success": 1 }
```

### Confirm Reset
```
POST /api/password_reminder
```
**Rate Limit:** 2 per minute

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `email` | string | Yes | Email address |
| `code` | string | Yes | 6-digit reset code |
| `password` | string | Yes | New password |

---

## 3. User Data

### Get User Data
```
POST /api/get_user_data
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API authentication hash |

**Response:**
```json
{
    "status": 1,
    "email": "user@example.com",
    "expiration_date": "2025-12-31",
    "days_left": 90,
    "plan": "Gold",
    "devices_limit": 100,
    "group_id": 1,
    "role_id": 1,
    "permissions": { ... }
}
```

---

## 4. Devices

### Get All Devices
```
POST /api/get_devices
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `s` | string | No | Search term (name/imei) |
| `page` | int | No | Page number (default: 1) |
| `limit` | int | No | Items per page (default: 100) |

**Response:** Array of device groups, each containing `id`, `title`, `items[]` (device objects).

### Get Devices JSON (Flat)
```
POST /api/get_devices_latest
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create Device (Form Data)
```
POST /api/add_device_data
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create Device
```
POST /api/add_device
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `imei` | string | Yes | Device IMEI number |
| `name` | string | Yes | Device name |
| `group_id` | int | No | Device group ID |
| `icon_id` | int | No | Device icon ID |
| `speed_max` | int | No | Max speed |
| `color` | string | No | Device color (hex) |
| `sensor_motor` | string | No | Motor sensor value |
| `min_fuel` | float | No | Min fuel value |
| `max_fuel` | float | No | Max fuel value |
| `fuel_function` | string | No | Fuel function |
| `comments` | string | No | Device comments |

### Edit Device
```
POST /api/edit_device
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Device ID |
| `imei` | string | Yes | Device IMEI |
| `name` | string | Yes | Device name |
| `group_id` | int | No | Device group ID |
| `icon_id` | int | No | Device icon ID |
| `speed_max` | int | No | Max speed |
| `color` | string | No | Device color |
| `active` | int | No | 1=active, 0=inactive |

### Change Active Status
```
POST /api/change_active_device
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Device ID |
| `active` | int | Yes | 1=active, 0=inactive |

### Enable Device
```
POST /api/enable_device
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Device ID |

### Disable Device
```
POST /api/disable_device
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Device ID |

### Delete Device
```
POST /api/destroy_device
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Device ID |

### Detach Device
```
POST /api/detach_device
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Device ID |

### Set Device Expiration
```
POST /api/set_device_expiration
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `imei` | string | Yes | Device IMEI |
| `expiration_date` | string | Yes | Date (YYYY-MM-DD) |

### Device Stop Time
```
GET /api/device_stop_time
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Device ID |

### Alarm Position
```
GET /api/alarm_position
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Device ID |

### Change Alarm Status
```
GET /api/change_alarm_status
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Device ID |

---

## 5. Device Sensors

### Get Sensors
```
POST /api/get_sensors
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | Yes | Device ID |

### Create Sensor (Form)
```
POST /api/add_sensor_data
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create Sensor
```
POST /api/add_sensor
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | Yes | Device ID |
| `name` | string | Yes | Sensor name |
| `type` | string | Yes | Sensor type |
| `color` | string | No | Sensor color |
| `min` | float | No | Min value |
| `max` | float | No | Max value |
| `unit` | string | No | Unit of measurement |
| `formula` | string | No | Calculation formula |

### Edit Sensor
```
POST /api/edit_sensor
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Sensor ID |
| `name` | string | Yes | Sensor name |
| `type` | string | Yes | Sensor type |

### Delete Sensor
```
POST /api/destroy_sensor
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Sensor ID |

---

## 6. Device Services

### Get Services
```
POST /api/get_services
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | Yes | Device ID |

### Create Service (Form)
```
POST /api/add_service_data
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create Service
```
POST /api/add_service
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | Yes | Device ID |
| `service_type_id` | int | Yes | Service type ID |
| `name` | string | Yes | Service name |
| `date` | string | No | Service date |
| `mileage` | float | No | Mileage at service |
| `cost` | float | No | Service cost |

### Edit Service
```
POST /api/edit_service
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Service ID |

### Delete Service
```
POST /api/destroy_service
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Service ID |

---

## 7. Alerts

### Get Alerts
```
POST /api/get_alerts
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create Alert (Form)
```
POST /api/add_alert_data
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create Alert
```
POST /api/add_alert
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `type` | string | Yes | Alert type (e.g., `speed`, `geofence`, `sos`, `fuel`, `IgnitionOn`, `IgnitionOff`, `alarm`) |
| `name` | string | Yes | Alert name |
| `active` | int | No | 1=active, 0=inactive |
| `devices` | array | No | Array of device IDs |
| `speed_max` | int | No | Max speed (for speed alerts) |
| `geofence_id` | int | No | Geofence ID (for geofence alerts) |
| `sms` | int | No | Send SMS notification (1=yes) |
| `email` | int | No | Send email notification (1=yes) |
| `sms_gateway` | int | No | Send via SMS gateway (1=yes) |
| `commands` | array | No | Array of command IDs to execute |
| `time_from` | string | No | Active from time (HH:mm) |
| `time_to` | string | No | Active to time (HH:mm) |
| `days` | array | No | Active days of week |

### Edit Alert
```
POST /api/edit_alert
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Alert ID |

### Change Alert Active
```
POST /api/change_active_alert
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Alert ID |
| `active` | int | Yes | 1=active, 0=inactive |

### Set Alert Devices
```
POST /api/set_alert_devices
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Alert ID |
| `devices` | array | Yes | Array of device IDs |

### Delete Alert
```
POST /api/destroy_alert
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Alert ID |

### Get Alert Commands
```
GET /api/get_alerts_commands
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Get Alerts Summary
```
GET /api/get_alerts_summary
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | Yes | Device ID |
| `date_from` | string | No | Start date |
| `date_to` | string | No | End date |

### Get Alert Types with Attributes
```
GET /api/get_alerts_attributes
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

---

## 8. Geofences

### Get Geofences
```
POST /api/get_geofences
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create Geofence (Form)
```
POST /api/add_geofence_data
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create Geofence
```
POST /api/add_geofence
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `name` | string | Yes | Geofence name |
| `area` | string | Yes | Polygon coordinates (WKT or JSON) |
| `color` | string | No | Geofence color (hex) |
| `group_id` | int | No | Geofence group ID |
| `active` | int | No | 1=active, 0=inactive |
| `speed_limit` | int | No | Speed limit in km/h |

### Edit Geofence
```
POST /api/edit_geofence
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Geofence ID |

### Change Geofence Active
```
POST /api/change_active_geofence
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Geofence ID (required if `group_id` not set) |
| `group_id` | int | Yes | Group ID (required if `id` not set) |
| `active` | int | No | 1=active, 0=inactive |

### Delete Geofence
```
POST /api/destroy_geofence
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Geofence ID |

### Point in Geofences
```
GET /api/point_in_geofences
```
**Rate Limit:** 30 per minute

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `lat` | float | Yes | Latitude |
| `lng` | float | Yes | Longitude |

**Response:**
```json
{
    "status": 1,
    "zones": ["Zone A", "Zone B"]
}
```

---

## 9. History

### Get History
```
POST /api/get_history
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Device ID |
| `date_from` | string | Yes | Start date (YYYY-MM-DD HH:mm:ss) |
| `date_to` | string | Yes | End date (YYYY-MM-DD HH:mm:ss) |
| `with_messages` | int | No | Include messages (1=yes) |

### Get History Messages (Paginated)
```
POST /api/get_history_messages
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Device ID |
| `date_from` | string | Yes | Start date |
| `date_to` | string | Yes | End date |
| `page` | int | No | Page number |

### Delete History Positions
```
POST /api/delete_history_positions
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Device ID |
| `date_from` | string | Yes | Start date |
| `date_to` | string | Yes | End date |

---

## 10. Events

### Get Events
```
POST /api/get_events
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | No | Filter by device |
| `date_from` | string | No | Start date |
| `date_to` | string | No | End date |

### Delete Events
```
POST /api/destroy_events
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `ids` | array | Yes | Array of event IDs |

---

## 11. Routes

### Get Routes
```
POST /api/get_routes
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create Route
```
POST /api/add_route
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `name` | string | Yes | Route name |
| `group_id` | int | No | Route group ID |
| `active` | int | No | 1=active, 0=inactive |

### Edit Route
```
POST /api/edit_route
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Route ID |

### Change Route Active
```
POST /api/change_active_route
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Route ID |
| `active` | int | Yes | 1=active, 0=inactive |

### Delete Route
```
POST /api/destroy_route
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Route ID |

---

## 12. Reports

### Get Reports
```
POST /api/get_reports
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Get Report Types
```
POST /api/get_reports_types
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create Report (Form)
```
POST /api/add_report_data
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create Report
```
POST /api/add_report
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `name` | string | Yes | Report name |
| `type` | string | Yes | Report type |
| `devices` | array | Yes | Array of device IDs |
| `date_from` | string | Yes | Start date |
| `date_to` | string | Yes | End date |

### Generate Report
```
POST /api/generate_report
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Report ID |

### Delete Report
```
POST /api/destroy_report
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Report ID |

---

## 13. POIs / Map Icons

### Get Available Map Icons
```
POST /api/get_map_icons
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Get User POIs
```
POST /api/get_user_map_icons
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create POI
```
POST /api/add_map_icon
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `map_icon_id` | int | Yes | Map icon ID |
| `lat` | float | Yes | Latitude |
| `lng` | float | Yes | Longitude |
| `name` | string | Yes | POI name |
| `description` | string | No | POI description |
| `group_id` | int | No | POI group ID |

### Edit POI
```
POST /api/edit_map_icon
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | POI ID |

### Change POI Active
```
POST /api/change_active_map_icon
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | POI ID |
| `active` | int | Yes | 1=active, 0=inactive |

### Delete POI
```
POST /api/destroy_map_icon
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | POI ID |

---

## 14. Send Commands

### Get Command Form Data
```
POST /api/send_command_data
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | Yes | Device ID |

### Send SMS Command
```
POST /api/send_sms_command
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | Yes | Device ID |
| `template_id` | int | Yes | SMS template ID |

### Send GPRS Command
```
POST /api/send_gprs_command
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | Yes | Device ID |
| `template_id` | int | Yes | GPRS template ID |
| `params` | string | No | Command parameters |

---

## 15. Drivers

### Get Drivers
```
POST /api/get_user_drivers
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create Driver (Form)
```
POST /api/add_user_driver_data
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create Driver
```
POST /api/add_user_driver
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `name` | string | Yes | Driver name |

### Edit Driver
```
POST /api/edit_user_driver
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Driver ID |
| `name` | string | Yes | Driver name |

### Delete Driver
```
POST /api/destroy_user_driver
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Driver ID |

---

## 16. Custom Events

### Get Custom Events
```
POST /api/get_custom_events
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Get Events by Device
```
POST /api/get_custom_events_by_device
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | Yes | Device ID |

### Get Protocols
```
POST /api/get_protocols
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Get Events by Protocol
```
POST /api/get_events_by_protocol
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `protocol` | string | Yes | Protocol name |

### Create Custom Event (Form)
```
POST /api/add_custom_event_data
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create Custom Event
```
POST /api/add_custom_event
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `name` | string | Yes | Event name |
| `protocol` | string | Yes | Protocol |
| `value` | string | Yes | Event value |

### Edit Custom Event
```
POST /api/edit_custom_event
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Custom event ID |

### Delete Custom Event
```
POST /api/destroy_custom_event
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Custom event ID |

---

## 17. SMS Templates

### Get SMS Templates
```
POST /api/get_user_sms_templates
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create SMS Template (Form)
```
POST /api/add_user_sms_template
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create SMS Template
```
POST /api/add_user_sms_template
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `name` | string | Yes | Template name |
| `message` | string | Yes | SMS message content |

### Edit SMS Template
```
POST /api/edit_user_sms_template
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Template ID |

### Get SMS Preview
```
POST /api/get_user_sms_message
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Template ID |
| `device_id` | int | Yes | Device ID |

### Delete SMS Template
```
POST /api/destroy_user_sms_template
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Template ID |

---

## 18. GPRS Templates

### Get GPRS Templates
```
POST /api/get_user_gprs_templates
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create GPRS Template (Form)
```
POST /api/add_user_gprs_template_data
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create GPRS Template
```
POST /api/add_user_gprs_template
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `name` | string | Yes | Template name |
| `message` | string | Yes | GPRS command message |
| `devices` | array | No | Array of device IDs |

### Edit GPRS Template
```
POST /api/edit_user_gprs_template
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Template ID |

### Get GPRS Preview
```
POST /api/get_user_gprs_message
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Template ID |
| `device_id` | int | Yes | Device ID |

### Delete GPRS Template
```
POST /api/destroy_user_gprs_template
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Template ID |

---

## 19. Sharing

### List Sharing
```
GET /api/sharing
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Get Sharing
```
GET /api/sharing/{id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Sharing ID (URL param) |

### Create Sharing
```
POST /api/sharing
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `email` | string | Yes | Email to share with |
| `devices` | array | No | Array of device IDs |
| `expiration_date` | string | No | Expiration date |

### Update Sharing
```
PUT /api/sharing/{id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Sharing ID (URL param) |
| `email` | string | No | Email |
| `devices` | array | No | Array of device IDs |

### Update Sharing Devices
```
PUT /api/sharing/{id}/devices
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Sharing ID (URL param) |
| `devices` | array | Yes | Array of device IDs |

### Delete Sharing
```
DELETE /api/sharing/{id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Sharing ID (URL param) |

---

## 20. Checklists

### Get Checklist Types
```
GET /api/checklists/types
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Get Checklists for Service
```
GET /api/checklists/{service_id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `service_id` | int | Yes | Service ID (URL param) |

### Create Checklist
```
POST /api/checklists/{service_id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `service_id` | int | Yes | Service ID (URL param) |
| `template_id` | int | Yes | Checklist template ID |

### Get Completed Checklists
```
GET /api/checklists/completed
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Get Failed Checklists
```
GET /api/checklists/failed
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Delete Checklist
```
DELETE /api/checklists
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Checklist ID |

### Update Row Status
```
PATCH /api/checklist_row/{row_id}/status
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `row_id` | int | Yes | Row ID (URL param) |
| `completed` | int | Yes | 1=completed, 0=not completed |

### Update Row Outcome
```
PATCH /api/checklist_row/{row_id}/outcome
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `row_id` | int | Yes | Row ID (URL param) |
| `outcome` | string | Yes | Outcome value |

### Upload Row File
```
POST /api/checklist_row/{row_id}/file
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `row_id` | int | Yes | Row ID (URL param) |
| `file` | file/base64 | Yes | Image file or base64 encoded |

### Delete Row File
```
DELETE /api/checklist_row/{row_id}/file
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `row_id` | int | Yes | Row ID (URL param) |
| `filename` | string | Yes | Filename to delete |

### Delete Row Image
```
DELETE /api/checklist_row/{image_id}/image
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `image_id` | int | Yes | Image ID (URL param) |

### Sign Checklist
```
PATCH /api/checklist/{checklist_id}/sign
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `checklist_id` | int | Yes | Checklist ID (URL param) |
| `signature` | string | Yes | Signature (base64 image) |
| `notes` | string | No | Notes |

### QR Code Image
```
GET /api/checklists/qr_code/image/{device_id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `device_id` | int | Yes | Device ID (URL param) |

Returns: PNG image

### QR Code Download
```
GET /api/checklists/qr_code/download/{device_id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `device_id` | int | Yes | Device ID (URL param) |

Returns: Downloadable PNG file

---

## 21. Checklist Templates

### List Templates
```
GET /api/checklists/templates
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create Template
```
POST /api/checklists/templates
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `name` | string | Yes | Template name |
| `type` | string | Yes | Template type |
| `rows` | array | Yes | Array of row definitions |

### Update Template
```
PATCH /api/checklists/templates/{template_id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `template_id` | int | Yes | Template ID (URL param) |
| `name` | string | No | Template name |
| `rows` | array | No | Array of row definitions |

### Delete Template
```
DELETE /api/checklists/templates
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Template ID |

---

## 22. Services (Device Maintenance)

### Get Services
```
GET /api/services/{device_id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | Yes | Device ID (URL param) |

### Get Create Data
```
GET /api/services/{device_id}/create_data
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | Yes | Device ID (URL param) |

### Create Service
```
POST /api/services/{device_id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | Yes | Device ID (URL param) |

### Get Edit Data
```
GET /api/service/{service_id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `service_id` | int | Yes | Service ID (URL param) |

### Update Service
```
PATCH /api/service/{service_id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `service_id` | int | Yes | Service ID (URL param) |

### Delete Service
```
DELETE /api/service/{service_id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `service_id` | int | Yes | Service ID (URL param) |

---

## 23. Call Actions

### List Call Actions
```
GET /api/call_actions
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Get Call Action
```
GET /api/call_actions/{id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Call action ID (URL param) |

### Create Call Action
```
POST /api/call_actions/store
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `name` | string | Yes | Action name |
| `event_type` | string | Yes | Event type |
| `response_type` | string | Yes | Response type |
| `phone` | string | Yes | Phone number |
| `devices` | array | No | Array of device IDs |

### Update Call Action
```
PUT /api/call_actions/update/{id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Call action ID (URL param) |

### Delete Call Action
```
DELETE /api/call_actions/destory/{id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Call action ID (URL param) |

### Get Event Types
```
GET /api/call_actions/event_types
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Get Response Types
```
GET /api/call_actions/response_types
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

---

## 24. Custom Fields

### Get Device Custom Fields
```
GET /api/device/custom_fields
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Get User Custom Fields
```
GET /api/user/custom_fields
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

---

## 25. Task Sets

### List Task Sets
```
GET /api/task_sets
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Get Task Set
```
GET /api/task_sets/{id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Task set ID (URL param) |

### Create Task Set
```
POST /api/task_sets
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `name` | string | Yes | Task set name |
| `description` | string | No | Description |

### Update Task Set
```
PUT /api/task_sets/{id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Task set ID (URL param) |

### Delete Task Set
```
DELETE /api/task_sets/{id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Task set ID (URL param) |

---

## 26. Tasks

### Get Tasks
```
GET /api/get_tasks
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | No | Filter by device |

### Get Task
```
GET /api/get_task/{id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Task ID (URL param) |

### Get Task Statuses
```
GET /api/get_tasks_statuses
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Get Task Priorities
```
GET /api/get_tasks_priorities
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Get Task Custom Fields
```
GET /api/get_tasks_custom_fields
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create Task
```
POST /api/add_task
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | Yes | Device ID |
| `task_set_id` | int | No | Task set ID |
| `name` | string | Yes | Task name |
| `description` | string | No | Task description |
| `priority` | int | No | Priority (0-3) |
| `assignee_id` | int | No | Assigned user/driver ID |
| `deadline` | string | No | Deadline date |

### Update Task
```
POST /api/edit_task/{id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Task ID (URL param) |
| `status` | int | No | Task status |
| `name` | string | No | Task name |
| `description` | string | No | Task description |
| `priority` | int | No | Priority |

### Delete Task
```
POST /api/destroy_task
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Task ID |

### Get Task Signature
```
GET /api/get_task_signature/{taskStatusId}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `taskStatusId` | int | Yes | Task status ID (URL param) |

Returns: JPEG image

---

## 27. Account Settings

### Edit Setup (Form)
```
POST /api/edit_setup_data
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Edit Setup
```
POST /api/edit_setup
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `name` | string | No | User name |
| `email` | string | No | Email |
| `language` | string | No | Language code |
| `timezone` | string | No | Timezone |
| `map_id` | int | No | Default map ID |
| `date_format` | string | No | Date format |
| `distance_unit` | string | No | `km` or `mi` |
| `volume_unit` | string | No | `l` or `gal` |
| `speed_unit` | string | No | `kmh` or `mph` |

### Change Password
```
POST /api/change_password
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `password` | string | Yes | Current password |
| `new_password` | string | Yes | New password |

### Get SMS Events
```
POST /api/get_sms_events
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Send Test SMS
```
POST /api/send_test_sms
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `phone` | string | Yes | Phone number |
| `message` | string | Yes | SMS message |

---

## 28. Device Media

### Get Device Images
```
GET /api/devices/{device_id}/media
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | Yes | Device ID (URL param) |

### Get Media File
```
GET /api/devices/{device_id}/media/file/{filename}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | Yes | Device ID (URL param) |
| `filename` | string | Yes | Filename (URL param) |

### Delete Media
```
DELETE /api/devices/{device_id}/media/{filename}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | Yes | Device ID (URL param) |
| `filename` | string | No | Filename (URL param, optional) |

---

## 29. Chat (Tracker)

### Get Device Alerts
```
GET /api/devices/{device_id}/alerts
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | Yes | Device ID (URL param) |

### Update Alert Time Period
```
POST /api/devices/{device_id}/alerts/{alert_id}/time_period
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device_id` | int | Yes | Device ID (URL param) |
| `alert_id` | int | Yes | Alert ID (URL param) |
| `date_from` | string | No | Start date |
| `date_to` | string | No | End date |

---

## 30. Address / Geolocation

### Geo Address (Reverse Geocode)
```
POST /api/geo_address
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `lat` | float | Yes | Latitude |
| `lon` | float | Yes | Longitude |

### Address Autocomplete
```
POST /api/address/autocomplete
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `q` | string | Yes | Search query |

---

## 31. FCM Token

### Set FCM Token
```
POST /api/fcm_token
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `token` | string | Yes | FCM token |

---

## 32. Admin - Clients

**Required Permission:** `auth.manager` middleware

### List Clients
```
GET /api/admin/clients
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Create Client
```
POST /api/admin/client
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `email` | string | Yes | Client email |
| `password` | string | Yes | Client password |
| `group_id` | int | No | Group ID |

### Update Client
```
PUT /api/admin/client
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Client user ID |

### Set Client Status
```
POST /api/admin/client/status
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Client user ID |
| `active` | int | Yes | 1=active, 0=inactive |

### Delete Client
```
DELETE /api/admin/client/{id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Client user ID (URL param) |

### Delete Multiple Clients
```
DELETE /api/admin/clients
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `ids` | array | Yes | Array of client IDs |

### Get Client Devices
```
GET /api/admin/client/{id}/devices
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Client user ID (URL param) |

### Client Secondary Credentials
```
GET    /api/admin/client/{user_id}/secondary_credentials
POST   /api/admin/client/{user_id}/secondary_credentials
PUT    /api/admin/client/{user_id}/secondary_credentials/{id}
DELETE /api/admin/client/{user_id}/secondary_credentials/{id}
```

---

## 33. Admin - Devices

### List All Devices
```
GET /api/admin/devices
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `s` | string | No | Search term |
| `limit` | int | No | Items per page (default: 50) |

### Get Device
```
GET /api/admin/device/{device}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device` | int | Yes | Device ID (URL param) |

### Get Device Users
```
GET /api/admin/device/{device}/users
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device` | int | Yes | Device ID (URL param) |

### Add User to Device
```
POST /api/admin/device/{device}/user
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device` | int | Yes | Device ID (URL param) |
| `user_id` | int | Yes* | User ID (*or `email`) |
| `email` | string | Yes* | User email (*or `user_id`) |

### Remove User from Device
```
DELETE /api/admin/device/{device}/user
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device` | int | Yes | Device ID (URL param) |
| `user_id` | int | Yes* | User ID (*or `email`) |
| `email` | string | Yes* | User email (*or `user_id`) |

### Set Device Status
```
POST /api/admin/device/{device}/status
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device` | int | Yes | Device ID (URL param) |
| `active` | int | Yes | 1=active, 0=inactive |

### Set Device Expiration
```
POST /api/admin/device/{device}/expiration
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `device` | int | Yes | Device ID (URL param) |
| `expiration_date` | string | Yes | Expiration date (YYYY-MM-DD) |

---

## 34. Admin - Companies

### List Companies
```
GET /api/admin/companies
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

### Get Company
```
GET /api/admin/companies/{id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Company ID (URL param) |

### Create Company
```
POST /api/admin/companies
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `name` | string | Yes | Company name |

### Update Company
```
PUT /api/admin/companies/{id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Company ID (URL param) |

### Delete Company
```
DELETE /api/admin/companies/{id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `id` | int | Yes | Company ID (URL param) |

---

## 35. Tracker App

**Base URL:** `/api/v2/tracker`

**Authentication:** `auth.tracker` middleware (device-based auth)

### Tracker Login
```
POST /api/v2/tracker/login
```

**Response:**
```json
{
    "success": true,
    "data": {
        "url": "http://tracker-server:5055",
        "device_id": 123,
        "channel": "md5hash"
    }
}
```

### Get Tasks
```
GET /api/v2/tracker/tasks
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `device_id` | int | Yes | Device ID (auto from auth) |

### Get Task Statuses
```
GET /api/v2/tracker/tasks/statuses
```

### Update Task Status
```
PUT /api/v2/tracker/tasks/{id}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | int | Yes | Task ID (URL param) |
| `status` | string | Yes | Status value |
| `signature` | string | Conditional | Base64 signature (required when status=`completed`) |

### Get Task Signature
```
GET /api/v2/tracker/tasks/signature/{taskStatusId}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `taskStatusId` | int | Yes | Task status ID (URL param) |

Returns: JPEG image

### Init Chat
```
GET /api/v2/tracker/chat/init
```

### Get Chat Users
```
GET /api/v2/tracker/chat/users
```

### Get Chat Messages
```
GET /api/v2/tracker/chat/messages
```

### Send Chat Message
```
POST /api/v2/tracker/chat/message
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `message` | string | Yes | Message content |

### Upload Image
```
POST /api/v2/tracker/position/image/upload
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `file` | file/base64 | Yes | Image file |
| `datetime` | string | Yes | Date/time (YYYY-MM-DD HH:mm:ss) |
| `category` | int | No | Media category ID |

### Get Media Categories
```
GET /api/v2/tracker/media_categories
```

### Set FCM Token (Tracker)
```
POST /api/v2/tracker/fcm_token
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `token` | string | Yes | FCM token |

---

## 36. Groups Management

### Device Groups
```
POST /api/devices_groups            # List
POST /api/devices_groups/store      # Create
POST /api/devices_groups/update/{id} # Update
```

### Geofence Groups
```
POST /api/geofences_groups            # List
POST /api/geofences_groups/store      # Create
POST /api/geofences_groups/update/{id} # Update
```

### Route Groups
```
POST /api/routes_groups            # List
POST /api/routes_groups/store      # Create
POST /api/routes_groups/update/{id} # Update
```

### POI Groups
```
POST /api/pois_groups            # List
POST /api/pois_groups/store      # Create
POST /api/pois_groups/update/{id} # Update
```

All group endpoints require:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `title` | string | Yes (store/update) | Group name |

---

## Geofence Device Reports (Rate Limited: 30/min)

### Devices in Geofences
```
GET /api/devices_in_geofences
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `geofence_id` | int | Yes | Geofence ID |
| `date_from` | string | Yes | Start date |
| `date_to` | string | Yes | End date |

### Devices Was in Geofence
```
GET /api/devices_was_in_geofence
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `geofence_id` | int | Yes | Geofence ID |
| `date_from` | string | Yes | Start date |
| `date_to` | string | Yes | End date |

### Devices Stay in Geofence
```
GET /api/devices_stay_in_geofence
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |
| `geofence_id` | int | Yes | Geofence ID |
| `date_from` | string | Yes | Start date |
| `date_to` | string | Yes | End date |

---

## Registration

### Check Registration Status
```
GET /api/registration_status
```

**Response:**
```json
{ "status": 1 }
```

### Register
```
POST /api/register
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `email` | string | Yes | Email address |
| `password` | string | Yes | Password |

---

## Services Keys

### Get Services Keys (Google Maps API)
```
POST /api/services_keys
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_api_hash` | string | Yes | API hash |

**Response:**
```json
{
    "status": 1,
    "items": {
        "maps": {
            "google": {
                "key": "AIza..."
            }
        }
    }
}
```

---

## Insert Position (Tracker)

```
POST /api/insert_position
```
Used by GPS tracking protocols to send position data.

---

## Notes

- **Authentication:** All authenticated endpoints require `user_api_hash` in the request body
- **Date Format:** Use `YYYY-MM-DD HH:mm:ss` unless specified otherwise
- **Pagination:** Most list endpoints support `page` and `limit` parameters
- **Permissions:** Admin endpoints require `auth.manager` middleware (admin/reseller role)
- **Tracker endpoints:** Use device-based authentication via `auth.tracker` middleware
- **Rate Limits:** Password reminder (2/min), geofence reports (30/min), device geofence reports (30/min)
