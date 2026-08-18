# Diagrama de Classes — PetConnect

Modelos de domínio (`lib/features/*/domain`) e a camada de repositório que os acessa (`lib/features/*/data`). Nomes e campos exatos serão ajustados quando a modelagem de Firestore já existente do usuário for incorporada (ver `docs/modelo-dados-firestore.md`).

```mermaid
classDiagram
    class Tutor {
        +String id
        +String name
        +String email
        +String? phone
        +String? photoUrl
        +DateTime createdAt
    }

    class Pet {
        +String id
        +String tutorId
        +String name
        +String species
        +String breed
        +DateTime birthDate
        +String? photoUrl
        +String qrCodeId
        +DateTime createdAt
    }

    class Vaccine {
        +String id
        +String petId
        +String name
        +DateTime appliedAt
        +DateTime? nextDoseAt
        +String? vet
        +String? notes
    }

    class MedicalRecord {
        +String id
        +String petId
        +DateTime date
        +String description
        +String? vet
        +List~String~ attachmentUrls
    }

    class AppointmentStatus {
        <<enumeration>>
        scheduled
        done
        canceled
    }

    class Appointment {
        +String id
        +String petId
        +DateTime date
        +String vetName
        +String reason
        +AppointmentStatus status
    }

    class AuthRepository {
        <<interface>>
        +signIn(email, password) Future~Tutor~
        +signUp(name, email, password) Future~Tutor~
        +sendPasswordReset(email) Future~void~
        +signOut() Future~void~
        +currentUser() Stream~Tutor?~
    }

    class PetRepository {
        <<interface>>
        +watchPets(tutorId) Stream~List~Pet~~
        +getPet(petId) Future~Pet~
        +createPet(pet) Future~String~
        +updatePet(pet) Future~void~
        +deletePet(petId) Future~void~
        +regenerateQrCode(petId) Future~String~
    }

    class VaccineRepository {
        <<interface>>
        +watchVaccines(petId) Stream~List~Vaccine~~
        +addVaccine(vaccine) Future~void~
        +updateVaccine(vaccine) Future~void~
        +deleteVaccine(id) Future~void~
    }

    class MedicalRecordRepository {
        <<interface>>
        +watchRecords(petId) Stream~List~MedicalRecord~~
        +addRecord(record) Future~void~
    }

    class AppointmentRepository {
        <<interface>>
        +watchAppointments(petId) Stream~List~Appointment~~
        +schedule(appointment) Future~void~
        +updateStatus(id, status) Future~void~
    }

    class FirestorePetRepository {
        -FirebaseFirestore firestore
    }

    Tutor "1" --> "many" Pet : possui
    Pet "1" --> "many" Vaccine : tem
    Pet "1" --> "many" MedicalRecord : tem
    Pet "1" --> "many" Appointment : tem
    Appointment --> AppointmentStatus

    PetRepository <|.. FirestorePetRepository : implementa
    PetRepository ..> Pet
    VaccineRepository ..> Vaccine
    MedicalRecordRepository ..> MedicalRecord
    AppointmentRepository ..> Appointment
    AuthRepository ..> Tutor
```

## Notas

- Repositórios são interfaces (`abstract class` em Dart) na camada `domain`, com implementação concreta usando Firestore na camada `data` — permite trocar a fonte de dados ou criar fakes para teste sem tocar na UI.
- `Pet.qrCodeId` é o identificador usado na URL pública (não deve ser sequencial — ver `docs/seguranca.md`).
- Providers Riverpod (camada `presentation/providers`) consomem essas interfaces, não as implementações concretas diretamente.
