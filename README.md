# loca_licious - Deine Restaurant-App mit Firestore! 🍔🍕🍣

![Screenshot 2025-04-01 at 23 58 59](https://github.com/user-attachments/assets/682610db-1ac6-4fa1-8b2d-412efac20d08)

**Finde, verwalte und teile deine Lieblingsrestaurants mit loca_licious!**

loca_licious ist eine Flutter-App, die dir hilft, Restaurants in deiner Nähe zu entdecken, zu bewerten und zu verwalten. Alle Daten werden in einer **Firestore-Datenbank** gespeichert, sodass du von überall auf deine Restaurantliste zugreifen kannst. Diese App zeigt dir, wie man mit **sauberen Repositories** und **Firebase/Firestore** arbeitet.

**Was kann loca_licious?**

Mit loca_licious kannst du:

*   **Restaurants suchen:** Durchstöbere eine Liste von Restaurants.
*   **Restaurants filtern:** Finde genau das, wonach du suchst, indem du die Restaurants nach Postleitzahl und/oder Bewertung filterst.
*   **Neue Restaurants hinzufügen:** Entdecke ein neues Restaurant? Füge es mit allen wichtigen Infos (Name, Adresse, Postleitzahl, Stadt, Kategorie und Bewertung) hinzu.
*   **Restaurants bearbeiten:** Hat sich etwas geändert? Bearbeite die Details von Restaurants, die du bereits hinzugefügt hast.
*   **Restaurants löschen:** Wenn du ein Restaurant nicht mehr in deiner Liste haben möchtest, kannst du es einfach löschen, indem du es nach links swipest.
*   **Restaurant-Details ansehen:** Klicke auf ein Restaurant, um mehr Details wie Adresse, Bewertung und Kategorie zu sehen.
*   **Bewertungen ansehen:** Sieh dir die Bewertung eines Restaurants an.
*   **Kategorien ansehen:** Sieh dir die Kategorie eines Restaurants an.
*   **Adresse ansehen:** Sieh dir die Adresse eines Restaurants an.
*   **Stadt ansehen:** Sieh dir die Stadt eines Restaurants an.

**Warum verwenden wir Repositories?**

In loca_licious verwenden wir **Repositories**, um den Code sauber und übersichtlich zu halten. Ein Repository ist wie ein Vermittler zwischen der App und der Datenbank. Es kümmert sich um alle Aufgaben, die mit dem Speichern und Abrufen von Daten zu tun haben. Das hat folgende Vorteile:

*   **Code-Trennung:** Der Code, der mit der Datenbank interagiert, ist von dem Code getrennt, der die Benutzeroberfläche (UI) erstellt.
*   **Einfachere Wartung:** Wenn sich die Art und Weise ändert, wie wir mit der Datenbank interagieren, müssen wir nur das Repository ändern, nicht den gesamten Code.
*   **Bessere Testbarkeit:** Repositories können leichter getestet werden, da sie unabhängig von der UI sind.

**Die Ordnerstruktur von loca_licious**

*   **`lib/`:** Hier ist der ganze Code der App.
    *   **`data/`:** Hier sind die Datenmodelle und die Repositories.
        *   **`models/`:** Hier sind die "Baupläne" für die Daten, z.B. wie ein Restaurant aussieht (`restaurant.dart`).
        *   **`repositories/`:** Hier ist der Code, der mit der Firestore-Datenbank kommuniziert.
            *   **`restaurants_repo.dart`:** Das Interface für das Repository.
            *   **`restaurants_repo_impl.dart`:** Die Implementierung des Repositories.
    *   **`features/`:** Hier sind die verschiedenen "Funktionen" der App.
        *   **`home/`:** Alles, was mit der Startseite zu tun hat, wo du die Liste der Restaurants siehst.
            *   **`filter_home_page.dart`:** Die Hauptseite mit der Filterfunktion.
            *   **`widgets/`:** Hier sind die einzelnen "Bausteine" der Startseite.
                *   **`add_restaurant_dialog.dart`:** Das Fenster, das sich öffnet, wenn du ein neues Restaurant hinzufügen möchtest.
                *   **`filter_view.dart`:** Die Filterleiste.
                *   **`restaurant_list_view.dart`:** Die Liste der Restaurants.
        *   **`detail/`:** Alles, was mit der Detailseite eines Restaurants zu tun hat.
            *   **`restaurant_details_page.dart`:** Die Detailseite für ein Restaurant.
            *   **`edit_restaurant_dialog.dart`:** Das Fenster, das sich öffnet, wenn du ein Restaurant bearbeiten möchtest.
    *   **`main.dart`:** Hier startet die App.

**Verwendete Packages:**

*   **Flutter:** Das Werkzeug, mit dem wir die App gebaut haben.
*   **`firebase_core`:** Das Werkzeug, das uns mit Firebase verbindet.
*   **`cloud_firestore`:** Das Werkzeug, mit dem wir die Daten in der Firestore-Datenbank speichern und abrufen.

**So benutzt du loca_licious**

1.  **Firebase Firestore einrichten:**
    *   Gehe zur Firebase-Konsole (https://console.firebase.google.com/) und erstelle ein neues Projekt oder wähle ein bestehendes aus.
    *   Klicke auf "Firestore-Datenbank" und dann auf "Datenbank erstellen".
    *   Wähle den "Testmodus" aus, um die Regeln für den Zugriff auf die Datenbank zu konfigurieren.
    *   Wähle einen Standort für deine Datenbank aus.
    *   Nachdem die Datenbank erstellt wurde, siehst du eine leere Datenbank.
2.  **Firestore-Struktur anlegen:**
    *   In Firestore legen wir eine Collection namens `restaurants` an.
    *   Jedes Restaurant ist ein Dokument in dieser Collection.
    *   Jedes Dokument hat folgende Felder:
        *   `id` (String): Die eindeutige ID des Restaurants (wird von Firestore generiert).
        *   `name` (String): Der Name des Restaurants.
        *   `rating` (int): Die Bewertung des Restaurants (1-5).
        *   `postalCode` (String): Die Postleitzahl des Restaurants.
        *   `adress` (String): Die Adresse des Restaurants.
        *   `city` (String): Die Stadt des Restaurants.
        *   `category` (String): Die Kategorie des Restaurants.
3.  **Testdaten hinzufügen:**
    *   Du kannst Testdaten manuell in der Firebase-Konsole hinzufügen, indem du auf "Collection hinzufügen" klickst und die Felder ausfüllst.
    *   Hier sind ein paar Beispiele für Testdaten:

        ```json
        {
          "id": "restaurant1",
          "name": "Pizzeria Bella Italia",
          "rating": 4,
          "postalCode": "10115",
          "adress": "Musterstraße 1",
          "city": "Berlin",
          "category": "Italienisch"
        }
        ```

        ```json
        {
          "id": "restaurant2",
          "name": "Sushi Bar Tokyo",
          "rating": 5,
          "postalCode": "80331",
          "adress": "Beispielweg 2",
          "city": "München",
          "category": "Japanisch"
        }
        ```

        ```json
        {
          "id": "restaurant3",
          "name": "Burger King",
          "rating": 3,
          "postalCode": "20095",
          "adress": "Hamburger Straße 3",
          "city": "Hamburg",
          "category": "Burger"
        }
        ```
    * Füge die Testdaten in Firestore hinzu.
4. **App starten:**
    * Nachdem du Firebase eingerichtet und Testdaten hinzugefügt hast, kannst du die App starten.
    * Die App zeigt dir nun die Testdaten an.
    * Du kannst nun neue Restaurants hinzufügen, bestehende bearbeiten und löschen.

**Hinweis:**

*   Anfängerfreundlich nur mit stateful
