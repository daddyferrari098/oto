import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Les états possibles de l'authentification
abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoggedInState extends AuthState {}

class AuthLoggedOutState extends AuthState {}

// Les événements possibles de l'authentification
abstract class AuthEvent {}

class AuthCheckEvent extends AuthEvent {}

class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;

  AuthSignInEvent({required this.email, required this.password});
}

class AuthSignOutEvent extends AuthEvent {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthCheckEvent) {
      // Vérifier ici l'état de connexion de l'utilisateur
      // Vous pouvez utiliser FirebaseAuth pour le faire
      if (FirebaseAuth.instance.currentUser != null) {
        yield AuthLoggedInState();
      } else {
        yield AuthLoggedOutState();
      }
    } else if (event is AuthSignInEvent) {
      // Se connecter avec l'email et le mot de passe fournis
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: event.email, password: event.password);
        yield AuthLoggedInState();
      } catch (e) {
        // Gérer les erreurs ici, par exemple afficher un message d'erreur à l'utilisateur
        print('Erreur lors de la connexion : $e');
        yield AuthLoggedOutState();
      }
    } else if (event is AuthSignOutEvent) {
      // Se déconnecter de l'application
      try {
        await FirebaseAuth.instance.signOut();
        yield AuthLoggedOutState();
      } catch (e) {
        // Gérer les erreurs ici, par exemple afficher un message d'erreur à l'utilisateur
        print('Erreur lors de la déconnexion : $e');
        yield AuthLoggedInState();
      }
    }
  }
}
