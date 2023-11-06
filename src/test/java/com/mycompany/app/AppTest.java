package com.mycompany.app;

import org.junit.Test;
import static org.junit.Assert.*;
import java.sql.DriverManager;
import org.rocksdb.*;

public class AppTest 
{
  @Test
  public void shouldAnswerWithTrue() throws Exception {

    RocksDB.loadLibrary();

    try (var conn = DriverManager.getConnection("jdbc:duckdb:")) {
      assertNotNull(conn);
    }
  }
}
