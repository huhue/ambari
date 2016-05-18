/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.ambari.view;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

/**
 * Provider of an input stream for a request to the Ambari server.
 */
public interface AmbariStreamProvider {
  /**
   * Read from the input stream specified by the given path on the Ambari server.
   *
   * @param path              the String to parse as an Ambari endpoint (e.g. /api/v1/users)
   * @param requestMethod     the HTTP method (GET,POST,PUT,etc.).
   * @param body              the body of the request; may be null
   * @param headers           the headers of the request; may be null
   *
   * @return the input stream
   *
   * @throws java.io.IOException if an error occurred connecting to the server
   */
  public InputStream readFrom(String path, String requestMethod, String body,
                              Map<String, String> headers) throws IOException,AmbariHttpException;

  /**
   * Read from the input stream specified by the given path on the Ambari server.
   *
   * @param path              the String to parse as an Ambari endpoint (e.g. /api/v1/users)
   * @param requestMethod     the HTTP method (GET,POST,PUT,etc.).
   * @param body              the body of the request; may be null
   * @param headers           the headers of the request; may be null
   *
   * @return the input stream
   *
   * @throws java.io.IOException if an error occurred connecting to the server
   */
  public InputStream readFrom(String path, String requestMethod, InputStream body,
                              Map<String, String> headers) throws IOException,AmbariHttpException;
}
