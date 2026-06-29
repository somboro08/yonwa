class Artisan {
  final int id;
  final String name;
  final String specialty;
  final String location;
  final double rating;
  final int reviews;
  final int price;
  final String bio;
  final List<String> tags;
  final String image;
  final String avatar;
  final List<String> products;
  final bool certified;

  const Artisan({
    required this.id,
    required this.name,
    required this.specialty,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.bio,
    required this.tags,
    required this.image,
    required this.avatar,
    required this.products,
    required this.certified,
  });
}

class Guide {
  final int id;
  final String name;
  final String specialty;
  final String location;
  final double rating;
  final int reviews;
  final int price;
  final List<String> languages;
  final String bio;
  final List<String> tags;
  final String image;
  final String avatar;
  final bool certified;
  final List<String> tours;

  const Guide({
    required this.id,
    required this.name,
    required this.specialty,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.languages,
    required this.bio,
    required this.tags,
    required this.image,
    required this.avatar,
    required this.certified,
    required this.tours,
  });
}

class Experience {
  final int id;
  final String title;
  final String category;
  final String duration;
  final String groupSize;
  final int price;
  final double rating;
  final int reviews;
  final String image;
  final String guide;
  final String description;
  final List<String> includes;
  final List<String> excludes;
  final String? badge;

  const Experience({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.groupSize,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.image,
    required this.guide,
    required this.description,
    required this.includes,
    required this.excludes,
    this.badge,
  });
}

class Category {
  final int id;
  final String name;
  final int count;
  final String color;
  final String image;
  final String iconName;

  const Category({
    required this.id,
    required this.name,
    required this.count,
    required this.color,
    required this.image,
    required this.iconName,
  });
}

class Notification {
  final int id;
  final String type;
  final String title;
  final String body;
  final String time;
  final bool read;

  const Notification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    required this.read,
  });
}

class ChatMessage {
  final int id;
  final String from;
  final String text;
  final String time;

  const ChatMessage({
    required this.id,
    required this.from,
    required this.text,
    required this.time,
  });
}

class BookingHistory {
  final int id;
  final String title;
  final String date;
  final String guide;
  final int price;
  final String status;
  final String image;

  const BookingHistory({
    required this.id,
    required this.title,
    required this.date,
    required this.guide,
    required this.price,
    required this.status,
    required this.image,
  });
}

class Conversation {
  final int id;
  final String name;
  final String lastMessage;
  final String time;
  final int unread;
  final String avatar;

  const Conversation({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
    required this.avatar,
  });
}
