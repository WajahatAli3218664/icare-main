# Chat with Pusher Real-Time Notifications Setup

## What's Already Done

### Backend (✅ Complete)
- Pusher configuration in `config/pusher.config.js`
- Chat controller with real-time events in `controllers/chatController.js`
- Chat routes with Pusher auth in `routes/chatRoutes.js`
- ChatMessage model in `models/chatmessage.js`
- Environment variables configured in `.env`:
  - PUSHER_APP_ID="2125244"
  - PUSHER_APP_KEY="f35e640cfef217a319dc"
  - PUSHER_APP_SECRET="af90c9b8f9ad63aae52c"
  - PUSHER_APP_CLUSTER="ap2"

### Flutter (✅ Basic Implementation)
- Chat service created: `lib/services/chat_service.dart`
- Chat screen UI: `lib/screens/chat_screen.dart`
- Chat list screen: `lib/screens/chat_list_screen.dart`

## What You Need to Add

### 1. Add Pusher Package to Flutter

Add to `pubspec.yaml`:
```yaml
dependencies:
  pusher_channels_flutter: ^2.2.1
```

Run: `flutter pub get`

### 2. Create Pusher Service for Real-Time Updates

Create `lib/services/pusher_service.dart`:

```dart
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_service.dart';

class PusherService {
  static final PusherService _instance = PusherService._internal();
  factory PusherService() => _instance;
  PusherService._internal();

  PusherChannelsFlutter? _pusher;
  final ChatService _chatService = ChatService();
  
  // Callbacks
  Function(Map<String, dynamic>)? onNewMessage;
  Function(String)? onTypingIndicator;
  Function(String)? onMessageRead;

  Future<void> initialize(String userId) async {
    _pusher = PusherChannelsFlutter.getInstance();
    
    try {
      await _pusher!.init(
        apiKey: 'f35e640cfef217a319dc',
        cluster: 'ap2',
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        onAuthorizer: onAuthorizer,
      );

      await _pusher!.subscribe(
        channelName: 'private-chat-$userId',
      );

      await _pusher!.connect();
    } catch (e) {
      print('Pusher initialization error: $e');
    }
  }

  dynamic onAuthorizer(String channelName, String socketId, dynamic options) async {
    try {
      final authData = await _chatService.getPusherAuth(socketId, channelName);
      return authData;
    } catch (e) {
      print('Pusher auth error: $e');
      return null;
    }
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print('Pusher connection: $previousState -> $currentState');
  }

  void onError(String message, int? code, dynamic e) {
    print('Pusher error: $message');
  }

  void onEvent(PusherEvent event) {
    print('Pusher event: ${event.eventName}');
    
    try {
      if (event.eventName == 'new-message') {
        final data = event.data as Map<String, dynamic>;
        onNewMessage?.call(data['message']);
      } else if (event.eventName == 'typing-indicator') {
        final data = event.data as Map<String, dynamic>;
        if (data['isTyping'] == true) {
          onTypingIndicator?.call(data['user']);
        }
      } else if (event.eventName == 'messages-read') {
        final data = event.data as Map<String, dynamic>;
        onMessageRead?.call(data['reader']);
      }
    } catch (e) {
      print('Error processing event: $e');
    }
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    print('Pusher subscribed to: $channelName');
  }

  void onSubscriptionError(String message, dynamic e) {
    print('Pusher subscription error: $message');
  }

  void onDecryptionFailure(String event, String reason) {
    print('Pusher decryption failure: $event');
  }

  void onMemberAdded(String channelName, PusherMember member) {
    print('Member added: ${member.userId}');
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    print('Member removed: ${member.userId}');
  }

  Future<void> disconnect() async {
    await _pusher?.disconnect();
  }

  Future<void> unsubscribe(String channelName) async {
    await _pusher?.unsubscribe(channelName: channelName);
  }
}
```

### 3. Update Chat Screen to Use Pusher

Modify `lib/screens/chat_screen.dart` to integrate Pusher:

```dart
// Add to imports
import '../services/pusher_service.dart';

// Add to _ChatScreenState
final PusherService _pusherService = PusherService();

// Update initState
@override
void initState() {
  super.initState();
  _loadChatHistory();
  _initializePusher();
}

Future<void> _initializePusher() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  
  if (userId != null) {
    await _pusherService.initialize(userId);
    
    // Listen for new messages
    _pusherService.onNewMessage = (message) {
      if (message['sender']['_id'] == widget.userId) {
        setState(() {
          _messages.add(message);
        });
        _scrollToBottom();
        _chatService.markAsRead(widget.userId);
      }
    };
  }
}

// Update dispose
@override
void dispose() {
  _messageController.dispose();
  _scrollController.dispose();
  _pusherService.onNewMessage = null;
  super.dispose();
}
```

### 4. How to Use Chat in Your App

#### From Doctor Profile (Patient viewing doctor):
```dart
// In doctor_detail.dart or similar
ElevatedButton(
  onPressed: () {
    ChatListScreen.openChat(
      context,
      userId: doctor['_id'],
      userName: doctor['user']['name'],
      userImage: doctor['user']['profileImage'],
    );
  },
  child: Text('Message Doctor'),
)
```

#### From Patient List (Doctor viewing patient):
```dart
// In patient list or appointment screen
IconButton(
  icon: Icon(Icons.chat),
  onPressed: () {
    ChatListScreen.openChat(
      context,
      userId: patient['_id'],
      userName: patient['name'],
      userImage: patient['profileImage'],
    );
  },
)
```

#### Add Chat Icon to AppBar:
```dart
AppBar(
  actions: [
    IconButton(
      icon: Icon(Icons.chat_bubble_outline),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatListScreen(),
          ),
        );
      },
    ),
  ],
)
```

## How Pusher Works

1. **Backend sends message** → Triggers Pusher event on receiver's channel
2. **Pusher** → Pushes notification to receiver's device in real-time
3. **Flutter app** → Receives event and updates UI instantly
4. **No polling needed** → Messages appear immediately

## Events Supported

- `new-message`: When someone sends you a message
- `message-sent`: Confirmation your message was sent
- `typing-indicator`: When someone is typing
- `messages-read`: When someone reads your messages

## Testing

1. Login with two different accounts on two devices/browsers
2. Open chat between them
3. Send message from one → Should appear instantly on the other
4. No need to refresh or pull to update

## Pusher Dashboard

Access your Pusher dashboard at: https://dashboard.pusher.com
- App ID: 2125244
- Monitor real-time connections
- View event logs
- Check usage statistics
