module default {
  abstract type HasAddress {
    required country: str {
      constraint min_len_value(2);
      constraint max_len_value(2);
    };
    required zipCode: str;
    required city: str;
    required address: str;
    required addressDetail: str;
  };

  abstract type HasTimestamps {
    required createdAt: datetime {
      readonly := true;
      default := datetime_of_statement();
    };

    required updatedAt: datetime {
      default := datetime_of_statement();
      rewrite update using (datetime_of_statement());
    };
  };


  type User extending HasTimestamps {
    required firstName: str;
    required lastName: str;

    required email: str;
    required phone: str;

    required passwordHash: str;

    #avatar_filename: str;
  }

  type Event extending HasAddress, HasTimestamps {
    title: str;
    required link organizer: Organizer;
    description: str;

    startsAt: datetime;
    endsAt: datetime;
    constraint expression on (.startsAt < .endsAt);

    # Location
    required placeName: str;

    multi link tickets := .<event[is Ticket];

    required ordinalNumberCounter: int64 {
      default := 0;
    };
  }

  type Ticket extending HasTimestamps {
    required token: str;

    badgeToken: str;
    badgeReceivedAt: datetime;

    multi link scans: Scan;
    property checkedIn := exists(.scans);

    required firstName: str;
    required lastName: str;

    required email: str;
    required phone: str;

    inviteCode: str;
    note: str;

    organizationName: str;

    gdprAccepted: bool;
    newsletterSubscribed: bool;

    required link event: Event {
      readonly := true;
    };

    #avatar_filename: str;
  }

  type Scan extending HasTimestamps {
    required link user: User;
  }

  type LinkOpen extending HasTimestamps {
    required link ticket: Ticket;
  }

  type Organizer extending HasAddress, HasTimestamps {
    required name: str;
    taxNumber: str;
    euTaxNumber: str;
    required phone: str;
    website: str;
    required email: str;

    # Socials
    facebook: str;
    facebookGroup: str;
    instagram: str;
    linkedin: str;
    threads: str;
    tiktok: str;

    #logo_filename: str;

    multi link users: User;

    link event := .<organizer[is Event];
  }
}
