package org.sitmun.plugin.core.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import org.sitmun.plugin.core.constraints.CodeList;
import org.sitmun.plugin.core.constraints.CodeLists;
import org.sitmun.plugin.core.constraints.HttpURL;

/**
 * Download file task.
 */
@Entity
@Table(name = "STM_DOWNLOAD")
@PrimaryKeyJoinColumn(name = "DOW_ID")
public class DownloadTask extends Task {

  /**
   * Download extension.
   */
  @Column(name = "DOW_EXT", length = 5)
  @NotNull
  @CodeList(CodeLists.DOWNLOAD_TASK_FORMAT)
  private String format;

  /**
   * Download scope.
   */
  @Column(name = "DOW_TYPE", length = 5)
  @NotNull
  @CodeList(CodeLists.DOWNLOAD_TASK_SCOPE)
  private String scope;

  /**
   * Location of the file to be downloaded.
   */
  @Column(name = "DOW_PATH", length = 5)
  @NotNull
  @HttpURL
  private String path;

  public String getFormat() {
    return format;
  }

  public void setFormat(String format) {
    this.format = format;
  }

  public String getScope() {
    return scope;
  }

  public void setScope(String scope) {
    this.scope = scope;
  }

  public String getPath() {
    return path;
  }

  public void setPath(String path) {
    this.path = path;
  }
}
