class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateUserProfileException extends CloudStorageException {}

class CouldNotGetUserProfileException extends CloudStorageException {}

class CouldNotUpdateUserProfileException extends CloudStorageException {}

class CouldNotDeleteUserProfileException extends CloudStorageException {}
