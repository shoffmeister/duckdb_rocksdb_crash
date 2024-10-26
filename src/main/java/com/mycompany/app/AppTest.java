package com.mycompany.app;

import java.sql.DriverManager;
import java.sql.SQLException;

import org.rocksdb.*;

public class AppTest 
{
  private static void runIt() throws SQLException {

    RocksDB.loadLibrary();

    try (var conn = DriverManager.getConnection("jdbc:duckdb:")) {
      System.out.println("Wombat connected");
    }
  }

  public static void main(String[] args) {
    try {
      runIt();
    } catch(Exception e) {
      System.out.println("Got some exception");
    }
  }
}
